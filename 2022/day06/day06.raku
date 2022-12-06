#!/usr/bin/env raku
for $*ARGFILES.lines».comb -> @data {
  for ^2 -> $part {
    my $winsize = 4 + 10 * $part;
    my $delta = $winsize - 1;
    for $delta..^@data -> $i {
      if $winsize == @data[($i-$delta)..$i].unique {
        say "Part {$part+1}: {$i+1}";
        last
      }
    }
  }
}
