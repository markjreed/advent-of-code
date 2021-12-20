#!/usr/bin/env raku
use Snailfish;

my $sum;
my @numbers = lines.map({ parse $_ });

# Part 1:
for @numbers -> $num {
  if !$sum.defined {
    $sum = $num;
  } else {
    $sum = add($sum, $num);
  }
}
say magnitude $sum;

# Part 2:
say @numbers.combinations(2).map({.permutations.map({ magnitude(add(|$_)) }).max}).max;
