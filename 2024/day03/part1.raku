#!/usr/bin/env raku
my regex mul { 'mul(' ( \d ** 1..3 ) ',' ( \d ** 1..3 ) ')' };
say (slurp() ~~ m:g/ <mul> /).map( -> $/ {
    $<mul>[0] * $<mul>[1]
}).sum;
