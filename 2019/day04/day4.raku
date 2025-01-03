#!/usr/bin/env raku
unit sub MAIN($input);

my ($low, $high) = $input.IO.lines[0].split('-')».Int;

my @part1 = ($low..$high).grep: { 
    .comb.sort eqv .comb && .comb.unique < .chars
};
say +@part1;

my @part2 = @part1.grep:  {
    ?(gather for m:g/(\d) {} $0/ -> $/ is copy {
        my $digit = $0;
        my $pattern = "<!after '$digit'> '$digit' '$digit' <!before '$digit'>";
        take ?m/<$pattern>/;
    }).grep(?*);
}
say +@part2;
