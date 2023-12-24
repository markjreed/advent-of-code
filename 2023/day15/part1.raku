#!/usr/bin/env raku
unit sub MAIN($input);
use Day15;

my @instructions = $input.IO.lines[0].split(',');

say [+](@instructions.map: { compute-hash($_) });
