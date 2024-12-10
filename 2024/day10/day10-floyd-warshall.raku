#!/usr/bin/env raku
use v6.e.PREVIEW;

unit sub MAIN($input);

my @map = $input.IO.lines.map(*.comb».Int.Array);
my $height = +@map;
my $width = +@map[0];

my @vertices = @map.kv.map(-> $i, @row { 
    @row.kv.map( -> $j, $cell { 
        $i * $width + $j;
    }).Array
});
my @coords = (^$height X ^$width);
say "Found {+@coords} vertices";

my @edges = gather for @map.kv -> $i, @row {
    for @row.kv -> $j, $level {
        my $u = @vertices[$i][$j];
        for ($i+1,$j),($i,$j+1) -> ($ni, $nj) {
            if 0 <= $ni < $height && 0 <= $nj < $width && 
                abs(@map[$i][$j] - @map[$ni][$nj]) == 1 {
                my $v = @vertices[$ni][$nj];
                if @map[$i][$j] < @map[$ni][$nj] {
                    #say "$i,$j {@map[$i][$j]} -> $ni,$nj {@map[$ni][$nj]}";
                    take [@vertices[$i][$j], @vertices[$ni][$nj]];
                } else {
                    #say "$ni,$nj {@map[$ni][$nj]} -> $i,$j {@map[$i][$j]}";
                    take [@vertices[$ni][$nj], @vertices[$i][$j]];
                }
            }
        }
    }
}
say "Found {+@edges} edges";

my @dist = @coords.map: { (Inf xx @coords).Array };
for @edges -> ($u, $v) {
    @dist[$u][$v] = 1;
}
for ^@coords -> $v { 
    @dist[$v][$v] = 0
}
for ^@coords -> $k {
    for ^@coords -> $i {
        for ^@coords -> $j {
            print "$k,$i,$j\r";
            my $through-k = @dist[$i][$k] + @dist[$k][$j];
            if $through-k < @dist[$i][$j] {
                @dist[$i][$j] = $through-k;
            }
        }
    }
}
say '';

my $total-score;
for @map.kv -> $i, @row {
    for @row.kv -> $j, $height {
        if $height == 0 {
            my $u = @vertices[$i][$j];
            $total-score += @dist[$u].kv.grep: -> $v, $d  { 
                $d < Inf && @map[||@coords[$v]] == 9
            };
        }
    }
}
say $total-score;
#.say for @map;
