#!/usr/bin/env raku
for $*ARGFILES.lines».comb -> @data {
  for ^2 -> $part {
    my $size = 4 + 10 * $part;
    for $size..@data -> $i {
      if $size == @data[($i-$size) ..^ $i].unique {
        print "{$part ?? "\t" !! ""}Part {$part+1}: $i";
        last
      }
    }
  }
  say '';
}
