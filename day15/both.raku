#!/usr/bin/env raku
my @risk = lines.map: { [.comb».Int ] };

sub find-path(@risk) {
  my @dist = [ Inf xx @risk[0] ] xx @risk;
  my @q = [[0,0],];
  @dist[0][0]=0;
  while @q {
    my ($i,$j) = @q.shift;
    for ( ($i-1,$j),($i,$j-1),($i,$j+1),($i+1,$j) ) -> ($ni, $nj) {
      next if $ni < 0 || $ni >= @risk || $nj < 0 || $nj >= @risk[$ni];
      if (my $dist = @dist[$i][$j] + @risk[$ni][$nj]) < @dist[$ni][$nj] {
        @dist[$ni][$nj] = $dist;
        @q.push: [$ni,$nj];
      }
    }
  }
  return @dist[@risk-1][@dist[@risk-1]-1];
}

my $height = +@risk;
my $width = +@risk[0];

say find-path(@risk);

# Build the bigger map
for ^5 X ^5 -> ($x,$y) {
  # first tile already filled in, no need to overwrite
  next unless $x || $y;
  for ^$height X ^$width -> ($i,$j) {
    @risk[$y*$height+$i][$x*$width+$j] = (@risk[$i][$j] + $x + $y - 1) % 9 + 1;
  }
}
say find-path(@risk);
