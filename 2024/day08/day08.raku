#!/usr/bin/env raku
my @map = lines()».comb;
my $height = +@map;
my $width = +@map[0];
my %antennae-locations;
for @map.kv -> $i, @row {
    for @row.kv -> $j, $sym {
        if $sym ~~ /<[a..zA..Z0..9]>/ {
            %antennae-locations{$sym}{"$i,$j"} = True;
        }
    }
}

my $antipodes = SetHash.new;
for %antennae-locations.kv -> $freq, $loc {
    my @loc = $loc.keys;
    for @loc.kv -> $n, $ij {
        my ($i0, $j0) = $ij.split(',');
        for $n+1..^@loc -> $m {
            my ($i1, $j1) = @loc[$m].split(',');
            my ($di, $dj) = ($i1,$j1) Z- ($i0,$j0);
            my $d = sqrt($di*$di + $dj*$dj);
            my ($ia,$ja) = ($i0,$j0) Z- ($di,$dj);
            $antipodes.set("$ia,$ja") if 0 <= $ia < $height && 0 <= $ja < $width;
            ($ia,$ja) = ($i1,$j1) Z+ ($di,$dj);
            $antipodes.set("$ia,$ja") if 0 <= $ia < $height && 0 <= $ja < $width;
        }
    }
}
say +$antipodes;
