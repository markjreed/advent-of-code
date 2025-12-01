#!/usr/bin/env raku
sub hash($value, \high_perm=(^256).pick(256),
               \low_perm=(^256).pick(256)) is export {
    my ($low, $high) »=» 0;
    for $value.polymod(256 xx 6) -> $c {
        my ($oldlow, $oldhigh) = $low, $high;
        $low  = low_perm[$low +^ $c.ord];
        $high = high_perm[$high  +^ $c.ord];
    }
    return mkword($high, $low)
}

sub mkword($msb, $lsb) is export {
    return (($msb +< 8) +| $lsb);
}
