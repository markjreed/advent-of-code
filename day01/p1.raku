#!/usr/bin/env raku
my @data = $*ARGFILES.lines;
say @data.rotor(2=>-1).map({ [<]($_) }).sum;
