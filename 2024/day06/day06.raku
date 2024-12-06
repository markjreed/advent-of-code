#!/usr/bin/env raku
my $DEBUG = False;

my @map = lines».comb».Array;

my ($gi, $gj, $gf);
my @dirs = «^ > v <»;
my %dir  = @dirs Z=> ^@dirs;
my @deltas = [-1, 0], [0, 1], [1, 0], [0, -1];

ROW: for @map.kv -> $i, @row {
    for @row.kv -> $j, $symbol {
        if %dir{$symbol}:exists {
            ($gi, $gj, $gf) = $i, $j, %dir{$symbol};
            @map[$gi][$gj] = 'X';
            last ROW;
        }
    }
}

if $DEBUG {
    .say for @map;
    say '';
    say "Guard starts at position ($gi, $gj) facing direction $gf ({@dirs[$gf]}).";
}

my $spaces = 1;
while 0 <= $gi < @map && 0 <= $gj < @map[$gi] {
    my ($ni, $nj) = ($gi, $gj) Z+ @(@deltas[$gf]);
    if 0 <= $ni < @map && 0 <= $nj < @map[$ni] {
        if @map[$ni][$nj] (elem) [ '.', 'X' ] {
            ($gi, $gj) = $ni, $nj;
            if @map[$ni][$nj] eq '.' {
                $spaces++;
                @map[$ni][$nj] = 'X';
            }
            if $DEBUG {
                say '';
                .say for @map;
            }
        } else {
            $gf  = ($gf + 1) % @dirs;
        }
    } else {
        ($gi, $gj) = $ni, $nj;
    }
}

if $DEBUG {
    say '';
    .say for @map;
    say "The guard's patrol covered $spaces spaces";
} else {
    say $spaces;
}
