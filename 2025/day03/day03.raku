#!/usr/bin/env raku
my \DEBUG = False;
my @digits = [2, 12];
my @parts = [0, 0];
for lines()».comb -> @bank {
    for @digits.kv -> $part, $count {
        my $joltage = '';
        my $last = -1;
        for ^$count -> $i {
            my ($index, $digit) = @bank[$last+1..*-$count+$i].pairs.max(->(:$key,:$value) { $value }).kv;
            $joltage ~= $digit;
            $last += 1 + $index;
        }
        say "{@bank.join('')}: $joltage" if DEBUG;
        @parts[$part] += $joltage;
    }
}
.say for @parts;
