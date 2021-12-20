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


sub explode-helper($n is rw, $level, $prev is rw, $next is rw, $pair is rw) {
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
    $pair = \($n);
    return $n;
  }
  my $left = explode-helper($n[0],$level+1,$prev,$next,$pair);
  my $right = explode-helper($n[1],$level+1,$prev,$next,$pair);
  return [$left, $right];
}

sub split($n) is export {
  my $done = False;
  split-helper($n, $done);
}

sub split-helper($n, $done is rw) {
  if $n ~~ Numeric && $n >= 10 && !$done {
    $done = True;
    return [ floor($n/2), ceiling($n/2) ];
  } elsif $n ~~ Numeric || $done {
    return $n;
  } else  {
    return [split-helper($n[0],$done), split-helper($n[1],$done)];
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
    my $split = split $n;
    $n = $split;
  } while $n !eqv $was;
  return $n;
}

sub tree($n,$prefix='') is export {
    if $n ~~ Numeric {
      return "$prefix$n\n";
    } else {
      return tree($n[0],"$prefix/") ~ tree($n[1],"$prefix\\");
    }
}
      

   
