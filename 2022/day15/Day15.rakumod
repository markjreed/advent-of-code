#!/usr/bin/env raku
unit module Day15;

# load the sensor/beacon data
sub parse-data($filename) is export {
  gather for $filename.IO.lines {
    my (($sx,$sy),($bx,$by)) :=
      m:g/'x=' ('-'?\d+) ', y=' ('-'?\d+)/».List».&{+$_};
       take [$sx,$sy,$bx,$by];
  }
}

# calculate the Manhattan distance between two points
sub manhattan($x1,$y1,$x2,$y2) is export {
  return abs($x2-$x1)+abs($y2-$y1);
}

# return a set of all points a given Manhattan distance from a center
sub fence($x0,$y0,$dist) is export {
  my $set = SetHash.new;
  for -$dist .. +$dist -> $dy {
    my $y = $y0 + $dy;
    my $left = $dist - abs($dy);
    $set.set($x0-$left+i*$y);
    $set.set($x0+$left+i*$y);
  }
  return $set;
}

# calculate the min and max x coordinates that, at a given y coordinate,
# are within a given Manhattan distance away from a central point
sub x-range($x,$y,$dist,$y-query) is export {
  my $dy = abs($y-query - $y);
  return 0 unless $dy <= $dist;
  my $dx = $dist - $dy;
  return $x - $dx .. $x + $dx;
}

# determine if two ranges overlap
sub overlap($r1, $r2) is export {
  $r1[0] <= $r2[0]   <= $r1[*-1] or
  $r1[0] <= $r2[*-1] <= $r1[*-1] or
  $r2[0] <= $r1[0]   <= $r2[*-1] or
  $r2[0] <= $r1[*-1] <= $r2[*-1];
}

# maintain a set of disjoint integer ranges
class RangeSet is export {
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
