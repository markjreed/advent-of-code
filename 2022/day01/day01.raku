#!/usr/bin/env raku
my @elves = $*ARGFILES.slurp.split("\n\n")».words».sum;
say "Part 1: {@elves.max}";
say "Part 2: {@elves.sort[*-3..*].sum}";
