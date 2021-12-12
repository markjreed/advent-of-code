#!/usr/bin/env raku
my @grid = lines.map: { [ .comb».Int ] };

my $size = [+] @grid;
say "size=$size";

my $new_flashes = 0;
my $total_flashes = 0;
my $n = 0;
while $new_flashes < $size {
  $new_flashes = 0;
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
    for $flashers.keys.List».&{.re,.im} -> ($i,$j) {
      next if @grid[$i][$j] == 0; # already flashed
      @grid[$i][$j] = 0;
      $new_flashes++;
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
  $total_flashes += $new_flashes if $n < 100;
  $n++;
}

say "Flashes after 100 steps: $total_flashes";
say "First step where all flash: $n";
