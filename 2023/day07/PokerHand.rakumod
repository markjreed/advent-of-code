#!/usr/bin/env raku
unit module PokerHand;

our @ranks = |(2..9), |(«T J Q K A»);
our %values;
our $wild;

unset-wild();

sub set-wild($rank) is export {
  $wild = $rank;
  %values{$rank} = 0;
}

sub unset-wild() is export {
  %values = @ranks.pairs.invert »+» 1;
  $wild = (Any);
}

sub counts($str) is export {
    my %histogram;
    %histogram{$_}++ for $str.comb;
    return %histogram;
}

sub hand-type($hand) is export {
  return 7 if $hand.comb.unique == 1; # five of a kind

  return 7 if $wild
           && $wild ∊ $hand.comb
           && $hand.comb.unique == 2;

  my %histo = counts($hand);
  return 6 if $hand.comb.unique == 2
           && %histo.values.max == 4; # four of a kind

  return 6 if $wild
           && $wild ∊ $hand.comb
           && $hand.comb.unique == 3 
           && %histo.keys.grep: -> $k {
             $k ne $wild  && %histo{$k} + %histo{$wild} == 4
           };

  return 5 if $hand.comb.unique == 2
           && %histo.values.max == 3
           && %histo.values.min == 2; # full house

  return 5 if $wild
           && $wild ∊ $hand.comb 
           && $hand.comb.unique == 3
           && %histo.keys.combinations(2).grep: -> ($a, $b) {
               $a ne $wild && $b ne $wild && (
                   (%histo{$a} == 3 && %histo{$b} + %histo{$wild} == 2)
                 ||
                   (%histo{$a} == 2 && %histo{$b} + %histo{$wild} == 3)
                 ||
                   (%histo{$b} == 2 && %histo{$a} + %histo{$wild} == 3)
                 ||
                   (%histo{$b} == 3 && %histo{$a} + %histo{$wild} == 2)
               )
          };

  return 4 if %histo.values.max == 3; # three of a kind
  return 4 if $wild
           && $wild ∊ $hand.comb
           && %histo.values.max == 2; # three of a kind

  return 3 if $hand.comb.unique == 3;     # two pair
  return 3 if $wild
           && $wild ∊ $hand.comb
           && $hand.comb.unique == 4
           && %histo.keys.combinations(2).grep: -> ($a, $b) {
               $a ne $wild && $b ne $wild && (
                   (%histo{$a} == 2 && %histo{$b} + %histo{$wild} == 2)
                 ||
                   (%histo{$b} == 2 && %histo{$a} + %histo{$wild} == 2)
               )
           };

  return 2 if $hand.comb.unique == 4;     # pair
  return 2 if $wild
           && $wild ∊ $hand.comb
           && $hand.comb.unique == 5;

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
