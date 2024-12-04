#!/usr/bin/env raku
my $ws = lines()».comb;
my $rows = +@$ws;
my $cols = +@$ws[0];

my $x-mas = 0;
my $height = +@$ws;
my $width = +@($ws[0]);
for 1..$height-2 -> $i {
    my $row = $ws[$i];
    for 1..$width-2 -> $j {
        my $letter = $row[$j];
        if $letter eq 'A' {
            my $positive = $ws[$i+1;$j-1] ~ $ws[$i-1;$j+1];
            my $negative = $ws[$i-1;$j-1] ~ $ws[$i+1;$j+1];
            $x-mas++ if ($positive eq 'MS' || $positive eq 'SM') &&
                        ($negative eq 'MS' || $negative eq 'SM') ;
        }
    }
}
say $x-mas;
