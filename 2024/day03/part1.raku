#!/usr/bin/env raku
say (slurp() ~~ m:g/'mul(' ( \d ** 1..3 ) ',' ( \d ** 1..3 ) ')'/).map( -> $/ { $0 * $1 }).sum;
