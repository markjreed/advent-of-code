#!/usr/bin/env raku
my @grid = [lines».comb».Int]».Array;

sub step { 
  my $flashes = 0;
  my $flashers = ().SetHash;
  my $was = +$flashers;
  for ^@grid -> $i {
    for ^@grid[$i]  -> $j {
      @grid[$i][$j] += 1;
      if @grid[$i][$j] > 9 {
        $flashers.set: $i+i*$j;
      }
    }
  }
  while +$flashers > $was {
    $was = +$flashers;
    for $flashers.keys -> $p is copy {
      $p=$p;
      my ($i,$j) = $p.&{.re,.im};
      next if @grid[$i][$j] == 0; # already flashed
      say "($i,$j) flashed; setting to 0";
      @grid[$i][$j] = 0; 
      $flashes++;
      for (-1..1) -> $di {
        my $ni = $i + $di;
        next if $ni < 0 || $ni >= @grid;
        for (-1..1) -> $dj {
          my $nj = $j + $dj;
          next if $nj < 0 || $nj >= @grid[$i];
          if @grid[$ni][$nj] > 0 { 
            @grid[$ni][$nj]++;
            if @grid[$ni][$nj] > 9 {
              $flashers.set: $ni +i*$nj;
            }
          }
        }
      }
    }
  }
  return $flashes;
}

my $total = 0;
for ^100 -> $i {
  say $i;
  $total += step;
  say "$total flashes";
}
say $total;
