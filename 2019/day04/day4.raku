#!/usr/bin/env raku
unit sub MAIN($input);

my ($low, $high) = $input.IO.lines[0].split('-')».Int;

my @part1 = ($low..$high).grep: { 
    .comb.sort eqv .comb && .comb.unique < .chars
};
say +@part1;

my @patterns = gather for ^10 -> $digit {
    take "<!after '$digit'> '$digit' '$digit' <!before '$digit'>";
}
    
my @part2 = @part1.grep: /<@patterns>/;
say +@part2;
