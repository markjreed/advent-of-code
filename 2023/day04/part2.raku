#!/usr/bin/env raku
unit sub MAIN($filename);

my $total = 0;
my @cards = $filename.IO.lines.map: -> $line {
    my ($left, $right) = 
      @($line ~~ /^'Card'\s+\d+':'( .* )'|'(.*)/)».Str».words».Set;
    +($left ∩ $right);
};
$total = @cards;
my @queue = ^$total;
while (@queue) {
    my $number = @queue.shift;
    if (my $card = @cards[$number]) {
        @queue.push( |[($number+1) .. ($number + $card)] );
        $total += $card
    }
}
say $total;
