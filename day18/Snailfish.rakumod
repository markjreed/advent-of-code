#!/usr/bin/env raku
unit module Snailfish;

grammar Parser {
    rule TOP { <pair> };
    rule pair { '[' <snailfish> ',' <snailfish> ']' };
    rule snailfish { <number> | <pair> };
    rule number { \d+ }
}

class ParserActions {
    method TOP($/) { make $<pair>.made; }
    method pair($/) { make $<snailfish>.map: *.made; }
    method snailfish($/) { make( $<number>.made // $<pair>.made ) };
    method number($/) { make +$/; }
}

sub parse($str) is export {
  Parser.parse($str, :actions(ParserActions)).made;
}

sub add($n1, $n2) is export { reduce [ $n1, $n2 ] }

sub magnitude($n) is export {
  $n ~~ Numeric  ?? $n !! 3 * magnitude($n[0]) + 2 * magnitude($n[1]);
}

sub copy($n) is export {
  $n ~~ Numeric  ?? $n !! [ (copy $n[0]), (copy $n[1]) ]
}


sub explode-helper($n is rw, $level, $prev is rw, $next is rw, $pair is rw) is export {
  if $n ~~ Numeric {
    if !$next {
      if $pair {
        $next = \($n);
      } else {
        $prev = \($n);
      }
    }
    return $n;
  }
  if $level == 4 && !$pair {
    if !$pair {
      $pair = \($n);
      return $n;
    }
  }
  return [explode-helper($n[0],$level+1,$prev,$next,$pair),
          explode-helper($n[1],$level+1,$prev,$next,$pair)];
}

sub split($n) is export {
  given $n {
    when Numeric { $n < 10 ?? $n !! [ floor($n/2), ceiling($n/2) ] }
    default { [ split($n[0]), split($n[1]) ] }
  }
}

sub explode($n) is export {
  my $new = copy($n);
  my $prev = Nil;
  my $next = Nil;
  my $pair = Nil;
  explode-helper($new, 0, $prev, $next, $pair);
  if $pair {
    my ($l, $r) = $pair[0];
    $pair[0] = 0;
    if $prev {
      $prev[0] += $l;
    }
    if $next {
      $next[0] += $r;
    }
  }
  return $new;
}

sub reduce($n is copy) is export {
  my $was;
  repeat {
    $was = copy $n;
    loop {
      my $exploded = explode $n;
      last if $n eqv $exploded;
      $n = $exploded;
    }
    loop {
      my $split = split $n;
      last if $n eqv $split;
      $n = $split;
    }
  } while $n !eqv $was;
  return $n;
}

