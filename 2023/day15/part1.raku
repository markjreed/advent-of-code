#!/usr/bin/env raku
unit sub MAIN($input);

my @instructions = $input.IO.lines[0].split(',');

say [+](@instructions.map: { compute-hash($_) });

sub compute-hash($str) {
    my $cv = 0;
    for $str.comb».ord -> $asc {
        $cv = (17 * ($cv + $asc)) +& 0xff;
    }
    return $cv;
}

