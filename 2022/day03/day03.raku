#!/usr/bin/env raku
my @lines = $*ARGFILES.lines;

# get the "priority" of an item: a-z are 1-26, A-Z 27-52
sub priority($s) {
  $s.ord +& 0x1f + 26 * ($s lt 'a');
}

my %parts = 1 => @lines».&{|[∩](.&{.comb.batch(.chars div 2)».SetHash}).keys},
            2 => @lines».&{.comb.SetHash}.batch(3).map({|[∩]($_).keys});

for %parts.kv -> $num, @items {
  say "Part $num: { [+] @items».&{priority $_} }";
}
