#!/usr/bin/env raku
unit sub MAIN($filename, $y-query);

# calculate the Manhattan distance between two points 
sub manhattan($x1,$y1,$x2,$y2) {
  return abs($x2-$x1)+abs($y2-$y1);
}

# calculate the min and max x coordinates that, at a given y coordinate,
# are within a given Manhattan distance away from a central point
sub x-range($x,$y,$dist,$y-query,$lower=-∞,$upper=+∞) {
  my $dy = abs($y-query - $y);
  return 0 unless $dy <= $dist;
  my $dx = $dist - $dy;
  return max($x - $dx,$lower) .. min($x + $dx,$upper);
}

# calculate the min and max y coordinates that, at a given x coordinate,
# are within a given Manhattan distance away from a central point
sub y-range($x,$y,$dist,$x-query,$lower=-∞,$upper=+∞) {
  my $dx = abs($x-query - $x);
  return 0 unless $dx <= $dist;
  my $dy = $dist - $dx;
  return max($y - $dy,$lower) .. min($y + $dy,$upper);
}

# determine if two ranges overlap
sub overlap($r1, $r2) {
  $r1[0] <= $r2[0]   <= $r1[*-1] or
  $r1[0] <= $r2[*-1] <= $r1[*-1] or
  $r2[0] <= $r1[0]   <= $r2[*-1] or
  $r2[0] <= $r1[*-1] <= $r2[*-1];
}

# maintain a set of disjoint integer ranges
class RangeSet {
  has @.ranges;
  method set($range) {
    return unless $range;
    my ($min, $max) = $range[0], $range[*-1];
    for @!ranges -> @range {
      if overlap(@range[0] .. @range[1], $range) {
        @range[0] = (@range[0], $min).min;
        @range[1] = (@range[1], $max).max;
        self.consolidate;
        return;
      }
    }
    @!ranges.push: [$min, $max];
  }
  method consolidate {
    my $new = RangeSet.new;
    for @!ranges -> $range {
      $new.set($range);
    }
    @!ranges = $new.ranges;
  }
}

my @beacon-data;
for $filename.IO.lines {
  my (($sx,$sy),($bx,$by)) :=
    m:g/'x=' ('-'?\d+) ', y=' ('-'?\d+)/».List».&{+$_};
  @beacon-data.push: [$sx,$sy,$bx,$by];
}

for ^2 -> $part {
  my $answer = [];
  my $lower = $part ?? 0 !! -∞;
  my $upper = $part ?? 2 * $y-query !! ∞;
  my @y = $part ?? $lower..$upper !! $y-query;
  for @y -> $y {
    my $x-ranges = RangeSet.new;
    my $beacon-x = SetHash.new;
    for @beacon-data -> ($sx, $sy, $bx, $by) {
      my $dist = manhattan($sx,$sy,$bx,$by);
      if $by == $y {
        $beacon-x.set($bx);
      }
      $x-ranges.set: x-range($sx,$sy,$dist,$y,$lower,$upper);
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
    if !$part {
      $answer = $total;
    } elsif $total == $upper-$lower {
      $answer.push: $y;
    }
  }
  @y = @($answer);
  my @x;
  if $part {
    for $lower..$upper -> $x {
      my $y-ranges = RangeSet.new;
      my $beacon-y = SetHash.new;
      for @beacon-data -> ($sx, $sy, $bx, $by) {
        my $dist = manhattan($sx,$sy,$bx,$by);
        if $bx == $x {
          $beacon-y.set($by);
        }
        $y-ranges.set: y-range($sx,$sy,$dist,$x,$lower,$upper);
      }
      my $total = [+] gather for $y-ranges.ranges -> ($min, $max) {
        my $count = $max - $min + 1;
        for $beacon-y.keys -> $by {
          if $min <= $by <= $max {
            $count--;
          }
        }
        take $count;
      }
      if $total == $upper-$lower {
        @x.push: $x;
      }
    }
    my @options;
    for @x X @y -> ($x, $y) {
      my $ok = True;
      for @beacon-data -> ($sx, $sy, $bx, $by) {
        if manhattan($sx,$sy, $x, $y) <= manhattan($sx,$sy, $bx, $by) {
          $ok = False;
        }
      }
      $answer = 4000000*$x+$y if $ok;
    }
  }
  say "Part {$part+1}: $answer";
}
