#!/usr/bin/env raku
my %pairs = '(' => ')', '[' => ']', '{' => '}', '<' => '>';
my %syntax_scores = ')' => 3, ']' => 57, '}' => 1197, '>' => 25137;
my %completion_scores = ')' => 1, ']' => 2, '}' => 3, '>' => 4;

my ($syntax_score, @line_scores);
Line:
for lines().kv -> $i,$line {
  my @stack;
  for $line.comb -> $ch {
    if $ch ~~ /'['|'('|'{'|'<'/ {
      @stack.push: $ch;
    } elsif $ch ~~ /']'|')'|'}'|'>'/ {
      my $last = @stack.pop;
      if $ch ne %pairs{$last} {
        $syntax_score += %syntax_scores{$ch};
        next Line;
      }
    }
  }
  if (@stack) {
    my $line_score = 0;
    while (@stack) {
      my $char = %pairs{@stack.pop};
      $line_score = $line_score*5+%completion_scores{$char};
    }
    @line_scores.push: $line_score;
  }
}
say "Syntax checker score: $syntax_score";
say "Middle autocompletion score: { @line_scores.sort.&{ $_[floor($_/2)] } }";
