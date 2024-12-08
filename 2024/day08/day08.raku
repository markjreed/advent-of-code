#!/usr/bin/env raku
my @map = lines()».comb».Array;
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

my $part1 = SetHash.new;
my $part2 = SetHash.new;
for ^$height -> $a {
    for ^$width -> $b {
        my $key = "$a,$b";
        for %antennae-locations.kv -> $freq, $loc {
            my @loc = $loc.keys;
            for @loc.kv -> $i, $mn {
                my ($m, $n) = $mn.split(',').map(+*);
                for ($i + 1) ..^ @loc -> $j {
                    my ($x, $y) = @loc[$j].split(',').map(+*);
                    if ($n - $b) * ($x - $m) == ($y - $n) * ($m - $a) {
                        $part2.set($key);
                        my ($c, $o, $z) = [$a, $m, $x].sort;
                        if $o - $c == $z - $o {
                            $part1.set($key);
                        } 
                    }
                }
            }
        }
    }
}
.say for +$part1, +$part2;
