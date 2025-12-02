#!/usr/bin/env raku
my @parts = (^2).map: { SetHash.new };

for lines()[0].split(',')».split('-') -> ($low, $high) {
    if $low.chars == $high.chars {
        scan($low, $high);
    } else {
        scan($low, 9 x $low.chars);
        scan(1 ~ 0 x $high.chars - 1, $high);
    }
}
.say for @parts».keys».sum;

sub scan($low, $high) {
    my $length = $low.chars;
    my @factors = (1 .. $length div 2).grep($length %% *).reverse;
    # not $length div 2 ... 1 because that produces a valid range
    # 0...1 when $length == 1, which we don't want. 1..0 is empty.
    for @factors -> $size {
        my $count = $length / $size;
        my ($lo, $hi) = ($low, $high).map: *.substr(0, $size).Int;
        for $lo .. $hi -> $piece {
            my $try = $piece x $count;
            if $low <= $try <= $high {
                @parts[1].set($try);
                @parts[0].set($try) if $count == 2;
            }
        }
    }
}
