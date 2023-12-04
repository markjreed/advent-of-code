#!/usr/bin/env raku
unit sub MAIN($filename);

my @counts = [ ];
my @cards = $filename.IO.lines.kv.map: -> $index, $line {
    @counts.push(1) if $index >= @counts;
    my ($left, $right) =
      @($line ~~ /^'Card'\s+\d+':'( .* )'|'(.*)/)».Str».words».Set;
    my $winners = +($left ∩ $right);
    for (^$winners) -> $next {
       my $won = $index + 1 + $next;
       if $won >= @counts {
         @counts.push(1);
       }
       @counts[$won] += @counts[$index];
    }
};
say @counts.sum;

# Sample data
# Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
# Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
# Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
# Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
# Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
# Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
#
# Sample run:
# @cards = []
# read card 1: @cards = [ 1 ]. $winners = 4. @cards = [ 1, 2, 2, 2, 2 ]
#
