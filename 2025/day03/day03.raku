#!/usr/bin/env raku
our constant \DEBUG = False;
my @digits = [2, 12];
my @parts = [0, 0];
for lines()».comb -> @bank {
    for ^2 -> $part {
        my $joltage = '';
        my $last = -1;
        for ^@digits[$part] -> $i {
            my ($j, $a) = @bank[$last+1..*-@digits[$part]+$i].pairs.max(->(:$key,:$value) { $value }).kv;
            $joltage ~= $a;
            $last += 1 + $j;
        }
        say "{@bank.join('')}: $joltage" if DEBUG;
        @parts[$part] += $joltage;
    }
}
.say for @parts;
