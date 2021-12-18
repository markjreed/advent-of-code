#!/usr/bin/env Raku

sub add($n1, $n2) { reduce [ $n1, $n2 ] }

sub magnitude($n) {
  $n ~~ Numeric  ?? $n !! 3 * magnitude($n[0]) + 2 * magnitude($n[1]);
}

sub copy($n) {
  $n ~~ Numeric  ?? $n !! [ (copy $n[0]), (copy $n[1]) ]
}

sub reduce($n) {
  my $was = copy $n;
  repeat {
    while (my $exploded = explode $n) ne $n {
      $n = $exploded;
    }
    while (my $split = split $n) ne $n {
      $n = $split;
    }
  } while $n ne $was;
  return $n;
}

sub explode($n) {
  my $new = copy($n);
  my $prev = Nil;
  my $next = Nil;
  my $pair = Nil;
  explode-helper($new, 0, $prev, $next, $pair);
  if $pair {
    my ($l, $r) = $pair[0];
    say "Exploding pair ($l,$r)";
    $pair[0] = 0;
    if $prev {
      say "Adding $l to {$prev[0]}";
      $prev[0] += $l;
    }
    if $next {
      say "Adding $r to {$next[0]}";
      $next[0] += $r;
    }
  }
  return $new;
}

sub explode-helper($n is rw, $level, $prev is rw, $next is rw, $pair is rw) {
  if $n ~~ Numeric  {
    if !$next {
      if $pair {
        $next = \($n);
      } else {
        $prev = \($n);
      }
    }
    return $n;
  }
  if $level == 4 {
    $pair = \($n);
    say "Exploding {$n.raku}, prev={$prev//'undefined'}";
  } else {
    return [explode-helper($n[0],$level+1,$prev,$next,$pair),
            explode-helper($n[1],$level+1,$prev,$next,$pair)]
  }
}

sub split($n) {
  given $n {
    when Numeric { $n < 10 ?? $n !! [ floor($n/2), ceiling($n/2) ] }
    default { [ split($n[0]), split($n[1]) ] }
  }
}
}
