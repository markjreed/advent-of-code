#!/usr/bin/env raku
use MONKEY-SEE-NO-EVAL;

my @pairs = $*ARGFILES.slurp.split("\n\n").map: {
  .split("\n").grep({$_}).map({
    .subst(']',',]',:g)
    .subst('[,','[',:g)
    .EVAL.Array
  }).Array
};

sub compare($left, $right) {
  if $left ~~ Int && $right ~~ Int {
    my $result = $left <=> $right;
    return $result;
  }

  if $left ~~ Array|List && $right ~~ Array|List {
    if !$left && +$right {
      return Less;
    } elsif !$right && +$left {
      return More;
    } elsif !$left {
      return Same
    }

    if my $result = compare($left[0], $right[0]) {
      return $result;
    }

    return compare($left[1..*], $right[1..*]);
  }

  if $left ~~ Int && $right ~~ Array|List {
    return compare([$left,], $right);
  }

  if $left ~~ Array && $right ~~ Int {
    return compare($left, [$right,]);
  }
}

sub in-order($left, $right) {
  compare($left, $right) == Less
}


my $total = 0;
for @pairs.kv -> $i, ($left, $right) { 
     $total += $i+1 if in-order($left, $right);
}
say "Part 1: $total";
my @dividers = [ [[2,],], [[6,],] ];
my @packets = (|@pairs.map(|*), |@dividers).sort(&compare);
my $part2 =  [*] @dividers.map: -> $div { 
                   |@packets.grep( { $_ eqv $div }, :k) »+» 1
                 };
say "Part 2: $part2";
