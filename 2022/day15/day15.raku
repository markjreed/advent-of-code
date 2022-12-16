#!/usr/bin/env raku
unit sub MAIN($filename, $y-query);

use Day15;

my @sensors = parse-data($filename);;
my $x-ranges = RangeSet.new;
my $beacon-x = SetHash.new;
for @sensors -> ($sx, $sy, $bx, $by) {
  my $dist = manhattan($sx,$sy,$bx,$by);
  if $by == $y-query {
    $beacon-x.set($bx);
  }
  $x-ranges.set: x-range($sx,$sy,$dist,$y-query);
}
my $total = [+] gather for $x-ranges.ranges -> ($min, $max) {
  my $count = $max - $min + 1;
  for $beacon-x.keys -> $bx {
    if $min <= $bx <= $max {
      $count--;
    }
  }
  take $count;
}
say "Part 1: $total";

# Part 2 is a bounded search
my ($lower, $upper) = (0, 2*$y-query);
my $possible = SetHash.new;

# Find the intersections of the perimeters of each sensor
# Given sensor 1 at x1,y1 with perimeter d1 and sensor 2 at x2,y2 with
# perimeter d2, these expressions will each give an
# intersection between them:
#
#   x = (d1-d2-y1+x1+x2+y2)/2,  y=x-x1+y1-d1
#   x = (d1-d2-y2+x1+x2+y1)/2,  y=d1+x1+y1-x
#   x = -(d1-d2-x1-x2-y1+y2)/2, y=x1+y1-d1-x
#   x = -(d1-d2-x1-x2-y2+y1)/2, y=x+y1+d1-x1
#
#   y = (d1-d2-x1+x2+y1+y2)/2,  x=y+x1-y1-d1
#   y = (d1-d2-x2+x1+y1+y2)/2,  x=d1+x1+y1-y
#   y = -(d1-d2-x1-y1-y2+x2)/2, x=x1+y1-y-d1
#   y = -(d1-d2-x2-y1-y2+x1)/2, x=y+x1+d1-y1
#
for @sensors.clone.kv -> $i, ($x1,$y1,$bx1,$by1) {
  my $d1 = manhattan($x1,$y1,$bx1,$by1)+1;
  for @sensors[$i+1..*].kv -> $j, ($x2,$y2,$bx2,$by2) {
    my $d2 = manhattan($x2,$y2,$bx2,$by2)+1;
    next if abs($x2-$x1)+abs($y2-$y1)==$d1-$d2; # identical fences, not helpful
    for  ($d1-$d2-$y1+$x1+$x2+$y2) => { $^x - $x1 + $y1 - $d1 },
         ($d1-$d2-$y2+$x1+$x2+$y1) => { $d1 + $x1 + $y1 - $^x },
        -($d1-$d2-$x1-$x2-$y1+$y2) => { $x1 + $y1 - $d1 - $^x },
        -($d1-$d2-$x1-$x2-$y2+$y1) => { $^x + $y1 + $d1 - $x1 } -> $pair {
      my $x = $pair.key / 2;
      next unless $x %% 1 && $lower <= $x <= $upper;
      my $y = $pair.value.($x);
      next unless $y %% 1 && $lower <= $y <= $upper;
      $possible.set($x+i*$y) if manhattan($x1,$y1,$x,$y)==$d1 && manhattan($x2,$y2,$x,$y)==$d2;
    }
    for  ($d1-$d2-$x1+$x2+$y1+$y2) => { $^y + $x1 - $y1 - $d1 },
         ($d1-$d2-$x2+$x1+$y1+$y2) => { $d1 + $x1 + $y1 - $^y },
        -($d1-$d2-$x1-$y1-$y2+$x2) => { $x1 + $y1 - $^y - $d1 },
        -($d1-$d2-$x2-$y1-$y2+$x1) => { $^y + $x1 + $d1 - $y1 } -> $pair {
      my $y = $pair.key / 2;
      next unless $y %% 1 && $lower <= $y <= $upper;
      my $x = $pair.value.($y);
      next unless $x %% 1 && $lower <= $x <= $upper;
      $possible.set($x+i*$y) if manhattan($x1,$y1,$x,$y)==$d1 && manhattan($x2,$y2,$x,$y)==$d2;
    }
  }
}

# eliminate points that are in range of a sensor
for $possible.keys.clone -> $p {
  my ($x,$y) = $p.&{.re,.im};
  for @sensors -> ($sx,$sy,$bx,$by) {
    if manhattan($sx,$sy,$x,$y) <= manhattan($sx,$sy,$bx,$by) {
      $possible.unset($p);
      last;
    }
  }
}

if !$possible {
  die "No solution.";
} elsif $possible > 1 {
  die "No unique solution.";
} else {
  my ($x, $y) = $possible.keys[0].&{.re, .im};
  say "Part 2: {4000000*$x+$y}";
}
