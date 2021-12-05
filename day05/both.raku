#!/usr/bin/env raku
my ($width, $height, @lines = []);
for $*ARGFILES.lines.kv -> $i, $line {
  my ($p1, $p2) = ($line.split: /\s*'->'\s*/).map: *.split(',').Array;
  my ($x1,$y1) = $p1.map: +*;
  my ($x2,$y2) = $p2.map: +*;
  $width  = [$x1, $x2, $width // $x1].max;
  $height = [$y1, $y2, $height // $y1].max;
  @lines.push([($x1,$y1), ($x2,$y2)]);
}

my @grid = [ 0 xx ($width+1) ] xx ($height+1);

for @lines -> $line {
  my ($p1, $p2) = $line;
  my ($x1,$y1) = $p1;
  my ($x2,$y2) = $p2;
  if $y1 == $y2 {
    if $x1 > $x2 {
      ($x1, $x2) = ($x2, $x1);
    }
    for $x1 .. $x2 -> $x {
      @grid[$y1][$x]++;
    }
  } elsif $x1 == $x2 {
    if $y1 > $y2 {
      ($y1, $y2) = ($y2, $y1);
    }
    for $y1 .. $y2 -> $y {
      @grid[$y][$x1]++;
    }
  }
}

say +(@grid».List.flat.grep: * > 1);

for @lines -> $line {
  my ($p1, $p2) = $line;
  my ($x1,$y1) = $p1;
  my ($x2,$y2) = $p2;
  if $x1 != $x2 && $y1 != $y2 {
    if $x1 > $x2 {
      ($x1, $x2) = ($x2, $x1);
      ($y1, $y2) = ($y2, $y1);
    }
    for $x1 .. $x2 -> $x {
      my $y = $y1 + ($x - $x1)/($x2 - $x1) * ($y2 - $y1);
      @grid[$y][$x]++;
    }
  }
}

say +(@grid».List.flat.grep: * > 1);

