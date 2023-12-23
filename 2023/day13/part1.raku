#!/usr/bin/env raku
unit sub MAIN($input);

my $total = 0;
for $input.IO.slurp.split("\n\n")».chomp».split("\n") -> @rows {
  if my @mirrors = find-mirrors(@rows) {
    for @mirrors -> $row {
       $total += 100 * $row;
     }
  }
  my @columns = [Z](@rows».comb)».join;
  if @mirrors = find-mirrors(@columns) {
    for @mirrors -> $col {
       $total += $col;
     }
  }
}
say $total;

sub find-mirrors(@strings) {
  gather for ^@strings.end -> $i {
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
     take $i+1 if $mirror;
  }
}
