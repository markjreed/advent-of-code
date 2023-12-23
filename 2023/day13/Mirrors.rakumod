unit module Mirrors;

sub find-mirror-in(@strings, $old) {
  for ^@strings.end -> $i {
    next if $i+1 == $old;
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
  return 0;
}

sub find-mirror(@rows, $old=0) is export {
   my $mirror = find-mirror-in(@rows, $old/100) * 100;
   return $mirror if $mirror && ($mirror != $old);
   my @columns = [Z](@rows».comb)».join;
   return find-mirror-in(@columns, $old);
}

sub find-smudged-mirror(@rows) is export {
   my $old = find-mirror(@rows);
   my $smudges = 0;
   for @rows.kv -> $i, $row {
       for ^$row.chars -> $j {
           $smudges++;
           my @smudged = |@rows[0..^$i],
                         toggle-char(@rows[$i],$j),
                         |@rows[$i^..*];
           my $new = find-mirror(@smudged, $old);
           return $new if $new && ($new != $old);
       }
    }
    return 0;
}

sub toggle-char($string, $index) {
    my $before = $string.substr(0, $index);
    my $char   = $string.substr($index,1);
    my $after  = $string.substr($index+1);
    $char = $char eq '.' ?? '#' !! '.';
    return $before ~ $char ~ $after;
}
