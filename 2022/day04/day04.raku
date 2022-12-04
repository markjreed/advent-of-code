#!/usr/bin/env raku
my @data = $*ARGFILES.lines».split(',')».&{Set([...] .split('-')».Int)};

say "Part 1: {+@data.grep: -> ($l,$r) { $l ⊆ $r or $r ⊆ $l }}";
say "Part 2: {+@data.grep: -> ($l,$r) { $l ∩ $r }}";
