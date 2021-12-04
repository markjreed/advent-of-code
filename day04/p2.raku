#!/usr/bin/env raku
my ($calls, @boards) = $*ARGFILES.slurp.split("\n\n");
my ($score, %winners);
for $calls.split(',') -> $ball {
  @boards .= map: { .subst( /«$ball»/, '*', :g) };
  for @boards.kv -> $i, $board {
    next if %winners{$i};
    if $board ~~ /(^ || \n) <[\x20]>* (\* <[\x20]>+)**4 \* / or
       $board ~~ / ( \* (\s+ \S+)**4 \s+ )**4 \* / {
        $score = $ball * [+]($board ~~ m:g/ \d+ /);
        %winners{$i} = True;
    }
  }
}
say "Final score was $score";
