#!/usr/bin/env perl
use v5.34;
use experimental qw(signatures);

sub find_path($height, $width, @risk) {
  my @dist;
  for (1..$height) {
    push @dist, [ ('inf') x $width ];
  }
  my @q = [0,0];
  $dist[0][0]=0;
  while (@q) {
    my ($i,$j) = @{shift @q};
    foreach my $n ( [$i-1,$j],[$i,$j-1],[$i,$j+1],[$i+1,$j] ) {
      my ($ni, $nj) = @$n;
      next if $ni < 0 || $ni >= @risk || $nj < 0 || $nj >= $risk[$ni];
      if ((my $dist = $dist[$i][$j] + $risk[$ni][$nj]) < $dist[$ni][$nj]) {
        $dist[$ni][$nj] = $dist;
        push @q, [$ni,$nj]
      }
    }
  }
  return $dist[$height-1][$width-1];
}

my @risk;
while (<>) {
  chomp;
  push @risk, [ split '' ];
}
my $height = @risk;
my $width = @{$risk[0]};

say find_path($height, $width, @risk);

# Build the bigger map
foreach my $y (0..4) {
  foreach my $x (0..4) {
    next unless $x || $y;
    foreach my $i (0..$height-1) {
      foreach my $j (0..$width-1) {
        $risk[$y*$height+$i][$x*$width+$j] = ($risk[$i][$j] + $x + $y - 1) % 9 + 1;
      }
    }
  }
}
$height = @risk;
$width = @{$risk[0]};
say find_path($height, $width, @risk);
