#!/usr/bin/env raku
unit sub MAIN($input);

my $total = 0;
for $input.IO.slurp.split("\n\n")».chomp».split("\n") -> @rows {
  my $mirror = find-mirror(@rows);
  if $mirror {
     $total += 100 * $mirror;
     next;
  }
  my @columns = [Z](@rows».comb)».join;
  if ($mirror = find-mirror(@columns)) {
    $total += $mirror;
  }
}
say $total;

sub find-mirror(@strings) {
  for ^@strings.end -> $i {
    my $mirror = True;
    for ^@strings -> $di {
      my ($a, $b) = $i - $di, $i + 1 + $di;
      if $a >= 0 && $a < @strings &&
         $b >= 0 && $b < @strings &&
         @strings[$a] ne @strings[$b] {
          $mirror = False;
          last;
       }
     }
     return $i+1 if $mirror;
  }
}
