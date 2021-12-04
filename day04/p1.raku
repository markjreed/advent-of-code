#!/usr/bin/env raku
my ($calls, @boards) = $*ARGFILES.slurp.split("\n\n");

for $calls.split(',') -> $ball {
  my $score;
  @boards .= map: { .subst( /«$ball»/, '*', :g) };
  for @boards.kv -> $i, $board {
    if $board ~~ /(^ || \n) ' '* ('*' ' '+)**4 '*' / or
       $board ~~ / ( '*' (\s+ \S+)**4 \s+ )**4 '*' / {
        $score = $ball * [+]($board ~~ m:g/ \d+ /);
        say "Board #$i wins on call of $ball with score $score.";
        last;
    }
  }
  last if $score;
}
