#!/usr/bin/env raku

class RangeList {
    has @.ranges of Range = [];

    method add(Range $range) {
        @!ranges.push: $range;
        @!ranges .= sort: *.min;
        my @result = [@!ranges.shift];
        while (@!ranges) {
            my $next = @!ranges.shift;
            my $last = @result.pop;
            if $next.min <= $last.max {
                @result.push: $last.min .. max($next.max, $last.max) ;
            } else {
                @result.push: $last;
                @result.push: $next;
            }
        }
        @!ranges = @result;
    }

    method ACCEPTS(Int $num) {
        ?@!ranges.grep: $num ~~ *;
    }

    method elems() returns Int {
        return [+] @!ranges».elems;
    }
}

my $fresh = RangeList.new;
my $part1 = 0;
for lines() {
    if /^ (\d+) '-' (\d+) / {
        $fresh.add: $0 .. $1;
    } elsif /^ (\d+) / {
        $part1++ if +$0 ~~ $fresh;
    }
}
say $part1;
say $fresh.elems;
