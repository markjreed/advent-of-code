#!/usr/bin/env raku
use Snailfish;

my $sum;
for lines.map({ parse $_ }) -> $num {
  if !$sum.defined {
    $sum = $num;
  } else {
    $sum = add($sum, $num);
  }
}
say $sum;
