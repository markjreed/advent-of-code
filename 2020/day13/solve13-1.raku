#!/usr/bin/env raku
unit sub MAIN($input-file);

my ($earliest-time, $buses) = $input-file.IO.lines;

my @buses = $buses.split(',').grep( * ne 'x' );

my ($bus, $boarding-time);
for @buses -> $b {
  my $q = $earliest-time / $b;
  $q .= ceiling  unless $q == $q.Int;
  my $can-board = $q × $b;
  if !$bus || $can-board < $boarding-time {
    $bus = $b;
    $boarding-time = $can-board;
  }
}

my $delta = $boarding-time - $earliest-time;
say "Can depart at $boarding-time on bus $bus, having waited $delta minutes.";
say "Product: $delta × $bus = {$delta × $bus}";
