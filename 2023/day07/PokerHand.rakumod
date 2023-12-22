#!/usr/bin/env raku
unit module PokerHand;

our @ranks = |(2..9), |(«T J Q K A»);
our %values = @ranks.pairs.invert;

sub counts($str) is export {
    my %histogram;
    %histogram{$_}++ for $str.comb;
    return %histogram;
}

sub hand-type($hand) is export {
  return 7 if $hand.comb.unique == 1; # five of a kind

  my %histogram = counts($hand);
  return 6 if $hand.comb.unique == 2
           && %histogram.values.max == 4; # four of a kind

  return 5 if $hand.comb.unique == 2
           && %histogram.values.max == 3
           && %histogram.values.min == 2; # full house

  return 4 if %histogram.values.max == 3; # three of a kind
  return 3 if $hand.comb.unique == 3;     # two pair
  return 2 if $hand.comb.unique == 4;     # pair
  return 1 if $hand.comb.unique == 5;     # high card
}

sub compare-hands($hand1, $hand2) is export {
    my $diff;
    return $diff if $diff =  hand-type($hand1) - hand-type($hand2);
    for ^5 -> $i {
      return $diff if $diff = 
        [-](($hand1,$hand2).map: { %values{.comb[$i]} } )
    }
    return 0;
}
