#!/usr/bin/env raku
my $dial = 50;
my ($part1, $part2) »=» 0;
for lines() {
    if m/^(<[LR]>)(\d+)$/ {
        my $was = $dial;
        $dial = ($dial + $1 * ($0 eq 'L' ?? -1 !! 1)) % 100;
        if $dial == 0 {
            $part1++; 
            $part2++;
        } elsif $was != 0 &&
            (($0 eq 'L' && $dial > $was) || ($0 eq 'R' && $dial < $was)) {
            $part2++;
        }
        if $1 >= 100 {
            $part2 += $1 div 100;
        }
    }
}
say $part1;
say $part2;
