#!/usr/bin/env raku
use Hash;

my @keys = lines.map(*.Int);
my $best = 0;
my $worst = Inf;
my $total = 0;
my \trials = 500;

for ^trials {
    print "$_/{trials}\r";
    my $high_perm = (^256).pick(256);
    my $low_perm = (^256).pick(256);
    my @hashes = @keys.map: { hash($_, $high_perm, $low_perm) +> 4};
    my $count = +@hashes.unique;
    $total += $count;
    if $count  > $best {
        $best = $count;
        #@best = ($high_perm, $low_perm);
    } 
    if $count < $worst {
        $worst = $count;
    }
}
say "best: $best, worst: $worst, average: {$total / trials}";
