#!/usr/bin/env raku
unit sub MAIN($input);

my @paths = $input.IO.lines».split(',')».Array;

my @wires = (^2).map: { { "0,0" => 0 } };

my ($part1, $part2) »=» Inf;
for (@paths Z @wires).kv -> $i, ($path, $wire) {
    my ($x, $y, $steps) »=» 0;
    for @($path) -> $leg {
        my ($dir, $count) = @($leg ~~ /^(<[RULD]>) (\d+)/).map(~*);
        for ^$count {
            $steps++;
            given $dir {
                when /R/ { $x++; }
                when /U/ { $y++; }
                when /L/ { $x--; }
                when /D/ { $y--; }
            }
            my $point = "$x,$y";
            if $wire{$point}:!exists {
                $wire{$point} = $steps;
            }
            if my $other = @wires[1-$i]{$point} {
                my $distance = abs($x) + abs($y);
                $part1 = $distance if $distance < $part1;
                my $total = $steps + $other;
                $part2 = $total if $total < $part2;
            }
        }
    }
}
say $part1;
say $part2;
