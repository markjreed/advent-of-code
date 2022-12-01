#!/usr/bin/env raku
unit sub MAIN($input-file, :@slopes = ['1/3']);

my $map = $input-file.IO.lines.map(*.comb);
my ($height, $width) = +$map, +$map[0];

my @counts = @slopes.map: -> $slope {
  my ($dy, $dx) = @( $slope ~~ m{ (\d+) <[/]> (\d+) } );
  my ($x,$y) = (0,0);
  my $trees =0;
  while ($y < $height) {
    $trees++ if $map[$y][$x] eq '#';
    $y += $dy;
    $x = ($x + $dx) % $width;
  }
  $trees;
}
say [*] @counts;


