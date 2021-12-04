#!/usr/bin/env raku
my $input = $*ARGFILES.slurp;

my ($calls, @boards) = $input.split("\n\n");

my @calls = $calls.split: ',';

my $score;
for @calls -> $ball {
  @boards .= map: { .subst( /«$ball»/, '*', :g) };
  for @boards.kv -> $i, $board {
    if $board ~~ /(^ || \n) \s* (\* <[\x20]>+)**4 \* / or
       $board ~~ / ( \* (\s+ \S+)**4 \s+ )**4 \* / {
        $score = $ball * [+]($board ~~ m:g/ \d+ /);
        say "Board #$i wins on call of $ball with score $score.";
        last;
    }
  }
  last if $score;
}
