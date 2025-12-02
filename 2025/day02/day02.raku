#!/usr/bin/env raku
my @parts = 0 xx 2;

for lines()[0].split(',')».split('-') -> ($low, $high) {
    if $low.chars == $high.chars {
        scan($low, $high);
    } else {
        scan($low, 9 x $low.chars);
        scan(1 ~ 0 x $high.chars - 1, $high);
    }
}
.say for @parts;

# The Möbius function μ
# When we find an n-fold repetition for part 2, we add the number times
# -μ(n) to our running total. Why?  For any positive n, the sum of μ(d) across
# all positive divisors d of n is 0. But that includes μ(1)=1, and we never
# find a "1-fold repetition". The sum of μ(d) across only the divisors d > 1
# must be -1 for the total to be 0, so if we always multiply by
# -μ(repetition-count), we will add a net value of 1 times the number to the
# sum.
sub μ($n) {
    return 1 if $n==1;
    my @factors = (1 .. $n).grep($n %% *);
    return 0 if @factors.grep: { $_ > 1 && sqrt($_) == sqrt($_).Int };
    return (-1)**@factors.grep: { is-prime($_) } 
}

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
                @parts[0] += $try if $count == 2;
                @parts[1] += $try * -μ($count);
            }
        }
    }
}
