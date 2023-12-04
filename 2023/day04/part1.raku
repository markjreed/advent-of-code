#!/usr/bin/env raku
unit sub MAIN($filename);

my $points = 0;
for $filename.IO.lines -> $line {
    my ($left, $right) = 
      @($line ~~ /^'Card'\s+\d+':'( .* )'|'(.*)/)».Str».words».Set;
    if (my $winners = +($left ∩ $right)) {
        $points += (1 +< ($winners - 1));
    }
}
say $points;
