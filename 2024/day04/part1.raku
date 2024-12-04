#!/usr/bin/env raku
my $ws = lines()».comb;
my $rows = +@$ws;
my $cols = +@$ws[0];

# more-forgiving indexing
sub postcircumfix:<᚜  ᚛>(@container,*@index) {
    my $c = @container;
    for @index -> $index {
        return (Any) if $index < 0 || !$c[$index];
        $c = $c[$index];
    }
    return $c;
}
    
no worries;
my $xmas = 0;
for @$ws.kv -> $i, $row {
    for @$row.kv -> $j, $letter {
        if $letter eq 'X' {
            for (-1, 0, 1) -> $di {
                for (-1, 0, 1) -> $dj {
                    $xmas++ if ($ws᚜$i+$di,$j+$dj᚛ // '') eq 'M' && 
                               ($ws᚜$i+2*$di,$j+2*$dj᚛// '')  eq 'A' && 
                               ($ws᚜$i+3*$di,$j+3*$dj᚛// '')  eq 'S';
                }
            }
        }
    }
}
say $xmas;
