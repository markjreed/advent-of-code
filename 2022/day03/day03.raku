#!/usr/bin/env raku
my @lines = $*ARGFILES.lines;

# get the "priority" of an item: a-z are 1-26, A-Z 27-52
sub priority($s) {
  $s.ord +& 0x1f + 26 * ($s lt 'a');
}

print "Part 1: "; say
  [+] @lines».&{|[∩](.&{.comb.batch(.chars div 2)».SetHash}).keys}».&{priority $_}

print "Part 2: "; say
  [+] @lines».&{.comb.SetHash}.batch(3).map({ |[∩]($_).keys})».&{priority $_};
