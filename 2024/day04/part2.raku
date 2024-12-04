#!/usr/bin/env raku
my $ws = lines()».comb;
my $rows = +@$ws;
my $cols = +@$ws[0];

# more-forgiving indexing
sub postcircumfix:<᚜  ᚛>(@container,*@indexes) {
    my $c = @container;
    for @indexes -> $index {
        return (Any) if $index < 0 || !$c[$index];
        $c = $c[$index];
    }
    return $c;
}
    
my $x-mas = 0;
for @$ws.kv -> $i, $row {
    for @$row.kv -> $j, $letter {
        if $letter eq 'A' {
            my $positive = ($ws᚜$i+1,$j-1᚛ // '') ~ ($ws᚜$i-1,$j+1᚛ // '');
            my $negative = ($ws᚜$i-1,$j-1᚛ // '') ~ ($ws᚜$i+1,$j+1᚛ // '');
            $x-mas++ if ($positive eq 'MS' || $positive eq 'SM') &&
                        ($negative eq 'MS' || $negative eq 'SM') ;
        }
    }
}
say $x-mas;
