#!/usr/bin/env raku
my @data = $*ARGFILES.lines;
say @data.rotor(3=>-2).map(*.sum).rotor(2=>-1).map({ [<]($_) }).sum;
