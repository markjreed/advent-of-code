#!/usr/bin/env raku
unit sub MAIN($input);
use PokerHand;

my @hands = $input.IO.lines».words;

@hands .= sort(-> $a, $b { compare-hands($a[0], $b[0]) } );

say [+](@hands.kv.map: -> $i, ($h, $b) { ($i+1) * $b })
