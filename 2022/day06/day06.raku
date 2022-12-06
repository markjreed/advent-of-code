#!/usr/bin/env raku
for $*ARGFILES.lines».comb -> @data {
  for ^2 -> $part {
    my $winsize = 4 + 10 * $part;
    my $delta = $winsize - 1;
    for ^(@data-$delta) -> $i {
      my $j = $i+$delta;
      if $winsize == +@data[$i..$j].unique {
        say "Part {$part+1}: {$j+1}";
        last
      }
    }
  }
}
