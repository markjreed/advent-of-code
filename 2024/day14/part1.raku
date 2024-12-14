#!/usr/bin/env raku
unit sub MAIN($input, $width=101, $height=103);

use Robots;

my $map = Robots.new(:width($width), :height($height));
for $input.IO.lines -> $line {
    my ($px, $py, $vx, $vy) = ($line ~~ m:g/ '-'? \d + /)».Int;
    $map.add-robot($px, $py, $vx, $vy);
}

$map.update(100);
say $map.safety-factor;
