#!/usr/bin/env raku
my @data = lines[0].split: ',';

my @counts = (^9).map: { @data.grep( $_ ) };

sub step-day(@counts) {
  |@counts[1..6],@counts[0]+@counts[7],@counts[8],@counts[0];
}

sub iterate($n, $func, $initial) {
  $n ?? iterate($n-1, $func, $func($initial)) !! $initial;
}

for (80,256) -> $day {
  say "Day $day: $([+] iterate($day, &step-day, @counts)) fish";
}
