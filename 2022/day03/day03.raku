#!/usr/bin/env raku
use MONKEY-TYPING;
my @lines = $*ARGFILES.lines;

augment class Str {
  method priority { 
    my $o = self.ord;
    $o % 32 + ($o < 97 ?? 26 !! 0);
  }
}

say "Part 1: {[+] @lines».&{ |[∩](.&{.comb.batch(.chars div 2)».SetHash}).keys }».priority}";

say "Part 2: {[+] @lines».&{.comb.SetHash}.batch(3).map({ |[(&)]($_).keys })».priority}";
