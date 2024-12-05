#!/usr/bin/env raku
my $ws = lines()».comb;
my $height = +@$ws;
my $width = +@($ws[0]);

my $xmas = 0;
my $x-mas = 0;

for @$ws.kv -> $i, $row {
    for @$row.kv -> $j, $letter {
        if $letter eq 'X' {
            for (-1,0, 1) -> $di {
                next unless 0 <= $i+3*$di < $height;
                for (-1,0, 1) -> $dj {
                    next unless 0 <= $j+3*$dj < $width;
                    next unless $di || $dj;
                    $xmas++ if $ws[$i+$di;$j+$dj]     eq 'M' && 
                               $ws[$i+2*$di;$j+2*$dj] eq 'A' && 
                               $ws[$i+3*$di;$j+3*$dj] eq 'S';
                }
            }
        }
        if 1 <= $i < $height - 1 && 1 <= $j < $width - 1 && $letter eq 'A' {
            my $positive = $ws[$i+1;$j-1] ~ $ws[$i-1;$j+1];
            my $negative = $ws[$i-1;$j-1] ~ $ws[$i+1;$j+1];
            $x-mas++ if ($positive eq 'MS' || $positive eq 'SM') &&
                        ($negative eq 'MS' || $negative eq 'SM') ;
        }
    }
}
say $xmas;
say $x-mas;
