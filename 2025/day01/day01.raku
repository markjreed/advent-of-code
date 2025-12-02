#!/usr/bin/env raku
my \DEBUG = False;
my $dial = 50;
my ($part1, $part2, $line) »=» 0;

if DEBUG {
    say "no,line,new,part1,part2";
    say "0,,50,0,0";
}

for lines() {
    $line++;
    if m/ ^ ( <[LR]> ) ( \d+ ) $ / {
        my $was = $dial;
        $dial = ($dial + $1 * ($0 eq 'L' ?? -1 !! 1)) % 100;
        if $dial == 0 {
            $part1++; 
            $part2++;
        } elsif $was != 0 &&
            (($0 eq 'L' && $dial > $was) || ($0 eq 'R' && $dial < $was)) {
            $part2++;
        }
        $part2 += $1 div 100;
    }
    say "$line,$_,$dial,$part1,$part2" if DEBUG;
}
say $part1;
say $part2;
