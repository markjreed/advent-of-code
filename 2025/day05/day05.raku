#!/usr/bin/env raku
my @fresh;
my $part1 = 0;
for lines() {
    if /^ (\d+) '-' (\d+) / {
        addFresh($0 .. $1);
    } elsif /^ (\d+) / {
        $part1++ if @fresh.grep: $0 ~~ *;
    }
}
say $part1;
say [+] @fresh».elems;

sub addFresh($new) {
    @fresh.push($new);
    @fresh .= sort: *.min;
    my @result = [@fresh.shift];
    while (@fresh) {
        my $next = @fresh.shift;
        my $last = @result.pop;
        if $next.min <= $last.max {
            @result.push( $last.min .. max($next.max, $last.max) );
        } else {
            @result.push( $last );
            @result.push( $next );
        }
    }
    @fresh = @result;
}
