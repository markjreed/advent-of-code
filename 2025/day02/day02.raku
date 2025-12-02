#!/usr/bin/env raku
my ($part1, $part2) »=» 0;
for lines()[0].split(',')».split('-') -> ($low, $high) {
    if $low.chars == $high.chars {
        scan($low, $high);
    } else {
        scan($low, 9 x $low.chars);
        scan(1 ~ 0 x $high.chars - 1, $high);
    }
}
say $part1;
say $part2;
sub scan($low, $high) {
    my $length = $low.chars;
    my @factors = (1..$length/2).grep: $length %% *;
    my (%counted1, %counted);
    for @factors -> $size {
        my $count = $length / $size;
        my ($lp, $hp) = ($low, $high).map: *.substr(0, $size).Int;
        for $lp .. $hp -> $piece {
            my $try = $piece x $count;
            if $low <= $try <= $high {
                if $count == 2 and %counted1{$try}:!exists {
                    $part1 += $try;
                    %counted1{$try} = True
                }
                if %counted{$try}:!exists {
                    $part2 += $try;
                    %counted{$try} = True
                }
            }
        }
    }
}
