#!/usr/bin/env raku
my @heightmap = lines».comb».Int;

# return the coordinates (i,j) plus all of its orthogonal neighbors
sub n5coords($matrix, $i, $j) {
  gather {
    for (-1,0,1).&{$_ X $_}.grep({ ![&&] $_ }) -> ($di,$dj) {
      my ($ni, $nj) = $i+$di, $j+$dj;
      take ($ni,$nj) if
        $ni >= 0 && $ni < $matrix && $nj >= 0 && $nj < $matrix[$ni];
    }
  }
}

sub neighborhood5($matrix, $i, $j) {
   n5coords($matrix,$i,$j).map(->($ni,$nj) { $matrix[$ni][$nj] })
}

sub basin($matrix, $i, $j, $visited is copy=().SetHash) {
   return $visited if $matrix[$i][$j] == 9;
   my $point = $i + i*$j;
   return $visited if $point ∈ $visited;
   $visited.set($point);
   for n5coords($matrix, $i, $j) -> ($ni, $nj) {
     $visited ∪= basin($matrix, $ni, $nj, $visited);
   }
   $visited;
}

my @basins;
my $risk;
for ^@heightmap -> $i {
  for ^@heightmap[$i] -> $j  {
    my $value = @heightmap[$i][$j];
    my @neighborhood = neighborhood5(@heightmap, $i, $j);
    if $value == @neighborhood.min && @neighborhood.grep($value) == 1 {
      @basins.push: basin(@heightmap, $i,$j);
      $risk += $value + 1
    }
  }
}
say $risk;
say [*] @basins».Int.sort({ +$^b <=> +$^a })[0..2];
