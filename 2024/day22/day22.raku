#!/usr/bin/env raku
unit sub MAIN($input);

sub prune($n) { $n +&  0b111111111111111111111111; }
sub mix($a, $b) { $a +^ $b; }

sub iterate($secret is copy) {
    $secret = prune(mix($secret, $secret +< 6));
    $secret = prune(mix($secret, $secret +> 5));
    $secret = prune(mix($secret, $secret +< 11));
    return $secret;
}

my @buyers = $input.IO.lines».Int;
my $part1;

my @price-changes = gather for @buyers -> $secret is copy {
    my %h;
    my @changes = ();
    for ^2000 {
        my $old = $secret % 10;
        $secret = iterate($secret);
        my $price = $secret % 10;
        @changes.push: $price - $old;
        if +@changes >= 4 {
            my $key = @changes[*-4..*-1].join(',');
            if %h{$key}:!exists {
                %h{$key} = $price;
            }
        }
    }
    take %h;
    $part1 += $secret;
}.Array;

say $part1;
my @keys = @price-changes.map(|*.keys).unique.Array;
my $max = 0;
my $max-key;

for @keys -> $key {
    my $sum = [+] @price-changes.map( { $_{$key}:exists ?? $_{$key} !! 0 } );
    if $sum > $max {
        $max = $sum;
        $max-key = $key;
    }
}
say $max;

#say @price-changes;
