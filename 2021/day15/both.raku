#!/usr/bin/env raku
sub find-path(@risk, $height, $width) {
  my @dist = [ Inf xx $width ] xx $height;
  my @q = [[0,0],];
  @dist[0][0]=0;
  while @q {
    my ($i,$j) = @q.shift;
    for ( ($i-1,$j),($i,$j-1),($i,$j+1),($i+1,$j) ) -> ($ni, $nj) {
      next if $ni < 0 || $ni >= $height || $nj < 0 || $nj >= $width;
      if (my $dist = @dist[$i][$j] + @risk[$ni][$nj]) < @dist[$ni][$nj] {
        @dist[$ni][$nj] = $dist;
        @q.push: [$ni,$nj];
      }
    }
  }
  return @dist[$height-1][$width-1];
}

my @risk = lines.map: { [.comb».Int ] };

my $height = +@risk;
my $width = +@risk[0];
say find-path(@risk, $height, $width);

# Build the bigger map
for ^5 X ^5 -> ($x,$y) {
  # first tile already filled in, no need to overwrite
  next unless $x || $y;
  for ^$height X ^$width -> ($i,$j) {
    @risk[$y*$height+$i][$x*$width+$j] = (@risk[$i][$j] + $x + $y - 1) % 9 + 1;
  }
}

$height = +@risk;
$width = +@risk[0];
say find-path(@risk, $height, $width);
