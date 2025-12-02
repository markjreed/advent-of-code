#!/usr/bin/env raku
my @parts = 0 xx 2;
my $examined = 0;

for lines()[0].split(',')».split('-') -> ($low, $high) {
    if $low.chars == $high.chars {
        scan-range($low, $high);
    } else {
        scan-range($low, 9 x $low.chars);
        scan-range(1 ~ 0 x $high.chars - 1, $high);
    }
}
.say for @parts;
say $examined;

# Look for invalid codes in the inclusive range [$low, $high];
#
# Approach: construct all the invalid codes in the vicinity of the range and
# check each one to ensure it's actually within the range. If it is, then let n
# be the number of repetitions of the identified base pattern:
#
# 1. multiply the code by -μ(n) (the negative Möbius function of the number of
# repetitions) and add the result to the part2 total.  
#
# 2. only if n is 2, also add the code (without any multiplying) to the part1
# total
#
# The motivation for the multiplication in #1 is to avoid overcounting codes. A
# code like `333333` is invalid according to part 2 in three different ways: as
# six repetitions of '3', three repetitions of '33', and two repetitions of
# '333'. Our logic will construct and count it thrice, generating a wrong
# answer if we add it to the total all three times. So we take advantage of the
# fact that the sum of μ(d) across all positive divisors d of n is 0, meaning
# the sum of all divisors > 1 (which are the only repetition counts we'll find
# since there's no such thing as a "1-fold repetition") is -1. 
#
# That works out like this: when we construct 333333 as '3' x 6, we will
# multiply 333333 x -μ(6) to get the number we add to the count. μ(6) is 1, so
# the product is -333333 and we wind up _subtracting_ 333333 from the total.
# μ(2) and μ(3) are both -1, so both other times we construct 333333, we will
# _add_ 333333. Thus we wind up adding a total of 333333 + 333333 - 333333,
# which sums to just one copy of 333333, as desired.
sub scan-range($low, $high) {

    my $length = $low.chars;

    my @factors = (1 .. $length div 2).grep($length %% *).reverse;
    # not $length div 2 ... 1 because that produces a valid range
    # 0...1 when $length == 1, which we don't want. 1..0 is empty.
    
    for @factors -> $size {
        my $count = $length / $size;
        my ($lo, $hi) = ($low, $high).map: *.substr(0, $size).Int;
        for $lo .. $hi -> $piece {
            $examined++;
            my $try = $piece x $count;
            if $low <= $try <= $high {
                @parts[0] += $try if $count == 2;
                @parts[1] += $try * -μ($count);
            }
        }
    }
}

# The Möbius function μ
# When we find an n-fold repetition for part 2, we add the number times
# -μ(n) to our running total. Why? 
sub μ($n) {
    return 1 if $n==1;
    my @factors = (1 .. $n).grep($n %% *);
    return 0 if @factors.grep: { $_ > 1 && sqrt($_) == sqrt($_).Int };
    return (-1)**@factors.grep: { is-prime($_) } 
}

