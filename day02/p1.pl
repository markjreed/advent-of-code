#!/usr/bin/env perl
use v5.34;
my ($pos, $depth) = (0,0);
while (<>) {
  if (/forward (\d+)/) { $pos+=$1 }
  elsif (/down (\d+)/) { $depth+=$1 }
  elsif (/up (\d+)/) { $depth-=$1 }
}
say $pos * $depth;
