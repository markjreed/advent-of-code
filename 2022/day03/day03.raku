#!/usr/bin/env raku
use MONKEY-TYPING;
my @lines = $*ARGFILES.lines;

augment class Str {
  method priority { 
    my $o = self.ord;
    $o +& 0x1f + ($o < 97 ?? 26 !! 0);
  }
}

print "Part 1: "; say
  [+] @lines».&{|[∩](.&{.comb.batch(.chars div 2)».SetHash}).keys}».priority;

print "Part 2: "; say
  [+] @lines».&{.comb.SetHash}.batch(3).map({ |[∩]($_).keys})».priority;
