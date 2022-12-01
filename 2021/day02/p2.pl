#!/usr/bin/env perl
use v5.34;
my ($aim, $pos, $depth) = (0,0,0);
while (<>) {
  if (/forward (\d+)/) { $pos+=$1; $depth += $aim * $1; }
  elsif (/down (\d+)/) { $aim+=$1 }
  elsif (/up (\d+)/) { $aim-=$1 }
}
say $pos * $depth;

