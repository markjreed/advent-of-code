#!/usr/bin/env raku
unit sub MAIN($input);
my @scanners;
my $s;
for $input.IO.lines {
    if m/^'---' \s+  'scanner' \s+ ( \d+ ) \s+ '---'/ {
        $s = +$0;
        @scanners[$s] = [];
    } elsif m:g/( \d+ )/ {
        my ($x,$y,$z) = $/.map(|*.values».Int);
        @scanners[$s].push([$x,$y,$z]);
    }
}

say @scanners[0].raku;
for ^(@scanners-1) -> $s0 {
    my @b0 = @($(@scanners[$s0]));
    for ($s0+1)..^@scanners -> $s1 {
        my @b1 = @($(@scanners[$s1]));
        my @delta = @(@b1[0]) Z- @(@b0[0]);
        say @delta.raku;
        exit;
    }
}
