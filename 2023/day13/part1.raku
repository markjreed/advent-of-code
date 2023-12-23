#!/usr/bin/env raku
unit sub MAIN($input);
use Mirrors;

my $total = 0;
for $input.IO.slurp.split("\n\n")».chomp».split("\n").kv 
  -> $p, @rows is copy {
  $total += (my $mirror = find-mirror(@rows));
  note "No reflection found for pattern {$p+1}" unless $mirror;
}
say $total;
