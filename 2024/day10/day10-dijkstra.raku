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

my %edges; 
for @map.kv -> $i, @row {
    for @row.kv -> $j, $level {
        my $u = @vertices[$i][$j];
        for ($i+1,$j),($i,$j+1) -> ($ni, $nj) {
            if 0 <= $ni < $height && 0 <= $nj < $width && 
                abs(@map[$i][$j] - @map[$ni][$nj]) == 1 {
                my $v = @vertices[$ni][$nj];
                if @map[$i][$j] < @map[$ni][$nj] {
                    #say "$i,$j {@map[$i][$j]} -> $ni,$nj {@map[$ni][$nj]}";
                    (%edges{$u} //= []).push: $v;
                } else {
                    (%edges{$v} //= []).push: $u;
                }
            }
        }
    }
}

my @dist = @coords.map: { (Inf xx @coords).Array };

for ^@coords -> $start {
    print "$start/{+@coords-1}\r";
    my $Q = SetHash.new(^@coords);
    @dist[$start][$start] = 0;
    while $Q {
         my $u = $Q.keys.min({ @dist[$start][$_]  });
         $Q.unset($u);
         for %edges{$u}.grep( { $Q{$_} } ) -> $v {
             my $alt = @dist[$start][$u] + 1;
             if $alt < @dist[$start][$v] {
                 @dist[$start][$v] = $alt;
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
            my $score += @dist[$u].kv.grep: -> $v, $d  { 
                $d < Inf && @map[||@coords[$v]] == 9
            };
            $total-score += $score;
        }
    }
}
say $total-score;
#.say for @map;
