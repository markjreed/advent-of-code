#!/usr/bin/env raku
unit sub MAIN($input, $width=101, $height=103, $start=0);

use Robots;

mkdir('frames');

my $map = Robots.new(:width($width), :height($height));
for $input.IO.lines -> $line {
    my ($px, $py, $vx, $vy) = ($line ~~ m:g/ '-'? \d + /)».Int;
    $map.add-robot($px, $py, $vx, $vy);
}
my (@vx, @vy);
my $count = 0;
for ^($width,$height).max -> $step {
    $map.save-frame(sprintf("frames/frame%04d.pbm", $count)) if $count >= $start;
    my @px = $map.robots».position»[0];
    my @py = $map.robots».position»[1];
    my $mx = ([+] @px) / @px;
    my $my = ([+] @py) / @py;
    @vx.push: [+](@px.map( (* - $mx) ** 2 )) / @px;
    @vy.push: [+](@py.map( (* - $my) ** 2 )) / @py;
    $map.update(1);
    $count += 1;
}
my $bx = @vx.min(:k)[0];
my $by = @vy.min(:k)[0];

my $s = $bx;
while $s % $height != $by {
    $s += $width;
} 

$start = $s if $s < $start;
$map.update($start - $count);
for $start .. $s -> $frame {
    $map.save-frame(sprintf("frames/frame%04d.pbm", $frame));
    $map.update(1);
}
