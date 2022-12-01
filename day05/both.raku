#!/usr/bin/env raku
my @lines = lines».split(' -> ')».split(',')».Int;
my $width = @lines.flat.kv.grep(-> $k, $v { $k%2 == 0 }).map(-> ($k,$v) {$v}).max;
say "width=$width";
