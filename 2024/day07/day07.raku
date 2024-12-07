#!/usr/bin/env raku
use Day07;
my ($part1, $part2) »=» 0;
for lines() -> $line {
    my ($goal, $components) = $line.split(':')».words;
    if try-to-make(+$goal[0], @$components.map(+*), False) {
        $part1 += $goal[0];
        $part2 += $goal[0];
    } elsif  try-to-make(+$goal[0], @$components.map(+*), True) {
        $part2 += $goal[0];
    }
}
say $part1;
say $part2;
