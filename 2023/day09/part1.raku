#!/usr/bin/env raku
unit sub MAIN($input);

my $total = 0;
for $input.IO.lines -> $line {
    my @values = $line.words;
    $total += next-value(@values);
}
say $total;

sub next-value(@sequence) {
    my @deltas = (1.. @sequence.end).map: { @sequence[$_] - @sequence[$_-1] };
    if @deltas.grep: * != 0 { 
       @deltas.push(next-value(@deltas));
    }
    return @sequence[*-1] + @deltas[*-1]
}
