#!/usr/bin/env raku
my %caves;
for lines.map(*.split('-')) -> ($l,$r) {
  (%caves{$l} //= ().SetHash).set($r);
  (%caves{$r} //= ().SetHash).set($l);
}

sub count-paths($next, $seen is copy=().SetHash, :$revisit-ok is copy=False,) {
   return 1 if $next eq 'end';
   my $is-small = ?($next ~~ /^<[a..z]>+$/);
   if $is-small && $seen{$next}  {
     if !$revisit-ok || $next eq 'start' {
       return 0;
     }
     $revisit-ok=False;
   }
   $seen ∪= $is-small ?? $next !! ();
   return [+] (count-paths($_, $seen, :revisit-ok($revisit-ok)) 
               for %caves{$next}.keys);
}

say count-paths('start');
say count-paths('start', :revisit-ok);
