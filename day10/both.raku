#!/usr/bin/env raku
my %pairs = '(' => ')', '[' => ']', '{' => '}', '<' => '>';
my %syntax-scores = ')' => 3, ']' => 57, '}' => 1197, '>' => 25137;
my %completion = '(' => '1', '[' => '2', '{' => '3', '<' => '4';

my ($syntax-score, @line-scores);
Line:
for lines() -> $line {
  my @stack;
  for $line.comb -> $ch {
    if $ch ~~ /'['|'('|'{'|'<'/ {
      @stack.push: $ch;
    } elsif $ch ~~ /']'|')'|'}'|'>'/ {
      my $last = @stack.pop;
      if $ch ne %pairs{$last} {
        $syntax-score += %syntax-scores{$ch};
        next Line;
      }
    }
  }
  if (@stack) {
    @line-scores.push:
      @stack.reverse.join.trans(%completion).parse-base(5);
  }
}
say "Syntax checker score: $syntax-score";
say "Middle autocompletion score: { @line-scores.sort.&{ $_[floor($_/2)] } }";
