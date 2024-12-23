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

say [+] gather for @buyers -> $secret is copy {
    for ^2000 {
        $secret = iterate($secret);
    }
    take $secret;
};
