#!/usr/bin/env raku
my ($calls, @boards) = $*ARGFILES.slurp.split("\n\n");
my ($first, $last, %winners);
for $calls.split(',') -> $ball {
  @boards .= map: { .subst(/«$ball»/, '*') };
  for @boards.kv -> $i, $board {
    next if %winners{$i};
    if $board ~~ /[[^ || \n] ' '* ['*' ' '+]**4 '*'] ||
                  [[ '*' [\s+ \S+]**4 \s+ ]**4 '*']/ {
        $last = $ball * [+]($board ~~ m:g/ \d+ /);
        $first //= $last;
        %winners{$i} = True;
    }
  }
}
.say for $first, $last;
