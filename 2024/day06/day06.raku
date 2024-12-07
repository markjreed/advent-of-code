#!/usr/bin/env raku
my $DEBUG = False;

my @map = lines».comb».Array;

my @dirs = «^ > v <»;
my %dir  = @dirs Z=> ^@dirs;
my @deltas = [-1, 0], [0, 1], [1, 0], [0, -1];

sub trace-patrol(@template) {
    my %patrol;
    my @map = @template».clone».Array.clone;

    my ($gi, $gj, $gf);
    ROW: for @map.kv -> $i, @row {
        for @row.kv -> $j, $symbol {
            if %dir{$symbol}:exists {
                ($gi, $gj, $gf) = $i, $j, %dir{$symbol};
                last ROW;
            }
        }
    }

    if $DEBUG {
        .say for @map;
        say '';
        say "Guard starts at position ($gi, $gj) facing direction $gf ({@dirs[$gf]}).";
    }

    while 0 <= $gi < @map && 0 <= $gj < @map[$gi] {
        my $coords = "$gi,$gj";
        if %patrol{$coords}{$gf} {
            return Inf;
        }
        %patrol{$coords}{$gf} = True;
        my ($ni, $nj) = ($gi, $gj) Z+ @(@deltas[$gf]);
        if 0 <= $ni < @map && 0 <= $nj < @map[$ni] {
            if @map[$ni][$nj] ∊ ['.', |@dirs] {
                ($gi, $gj) = $ni, $nj;
            } else {
                $gf  = ($gf + 1) % @dirs;
            }
        } else {
            ($gi, $gj) = $ni, $nj;
        }
    }
    return %patrol;
}

my %patrol = trace-patrol(@map);
if $DEBUG {
    say '';
    .say for @map;
    say "The guard's patrol covered {+%patrol} spaces";
} else {
    say +%patrol;
}

my $obstacle-locations = SetHash.new;
my $count = 0;
for %patrol.kv -> $coords, $directions {
    print "{++$count}/{+%patrol}\r";
    my ($i, $j) = $coords.split(',');
    for $directions.keys -> $dir {
        my ($oi, $oj) = ($i, $j) Z+ @(@deltas[$dir]);
        my $key = "$oi,$oj";
        if 0 <= $oi < @map && 0 <= $oj < @map[$oi] {
            if @map[$oi][$oj] eq '.' {
                @map[$oi][$oj] = '#';
                if trace-patrol(@map) == Inf {
                    $obstacle-locations.set("$oi,$oj")
                }
                @map[$oi][$oj] = '.';
            }
        }
    }
}
say $obstacle-locations.raku;
