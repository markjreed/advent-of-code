#!/usr/bin/env raku
unit sub MAIN($width, $height, $input);

my @data = $input.IO.lines.map(|*.comb);

my @layers = @data.batch($width * $height);

given @layers.min( *.grep( * == 0 ) ) -> @layer {
    say @layer.grep( * == 1 ) * @layer.grep( * == 2 );
}

my @pixels = (^$height).map({ (0 xx $width).Array }).Array;
for @layers.reverse -> @layer {
    for @layer.batch($width).kv -> $i, @row {
         for @row.kv -> $j, $color {
             @pixels[$i][$j]  = $color unless $color == 2;
         }
    }
}

for @pixels -> @row {
    say @row.map( { $_ != 0 ?? 'X' !! ' ' } ).join;
}
