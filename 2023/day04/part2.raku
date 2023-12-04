#!/usr/bin/env raku
unit sub MAIN($filename);

my $points = 0;
my @cards = $filename.IO.lines.map: -> $line {
    my ($left, $right) = 
      @($line ~~ /^'Card'\s+\d+':'( .* )'|'(.*)/)».Str».words».Set;
    +($left ∩ $right);
};
my @queue = @cards.pairs.clone;
while (@queue) {
    my ($number, $card) = @queue.shift.kv;
    if ($card) {
      for $number+1 .. $number + $card -> $won {
          @cards.push(@cards[$won]);
          @queue.push($won => @cards[$won])
      }
   }
}
say +@cards;
