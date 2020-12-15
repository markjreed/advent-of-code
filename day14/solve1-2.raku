#!/usr/bin/env raku
unit sub MAIN($input-file);

my ($mask, %mem);

sub apply-mask($mask, $value) {
  my @mask-bits = $mask.comb;
  my @result-bits = sprintf('%036b', $value).comb;
  for ^$@mask-bits -> $i {
    given @mask-bits[$i] {
      when '0' { ; }
      when any('1','X') { @result-bits[$i] = @mask-bits[$i]; }
    }
  }
  return [~] @result-bits;
}

sub store-value($masked-addr, $value) {
   my @bits = $masked-addr.comb;
   my $floating = +(@bits.grep: 'X');
   for ^(2**$floating) -> $i {
     my $bits = sprintf("\%0{$floating}b",$i);
     my $addr = $masked-addr;
     for $bits.comb -> $repl {
        $addr ~~ s/X/$repl/;
     }
     my $key = :2($addr);
     %mem{$key} = $value;
   }
}

grammar Bitmask {
  token TOP { <instruction>+ %% "\n" }
  token instruction { <set-mask> | <store-value> }
  token set-mask { 'mask' \s* '=' \s* <mask-value> }
  token mask-value { <[X01]> ** 36 }
  token store-value { 'mem[' <index> ']' \s* '=' \s* <value> }
  token index { <number> };
  token value { <number> };
  token number { \d+ }
}

class Bitmask-Actions {
  method TOP($/) { make $<instruction>.map: *.made }
  method instruction($/) {
    make $<set-mask> ?? $<set-mask>.made !! $<store-value>.made
  }
  method set-mask($/) {
    make { $mask = ~ $<mask-value> }
  }
  method store-value($/) {
    make { store-value(apply-mask($mask, $<index>.made), $<value>.made) };
  }
  method index($/) { make $<number>.made; }
  method value($/) { make $<number>.made; }
  method number($/) { make +$/; }
}

my @program = Bitmask.parse($input-file.IO.slurp, actions => Bitmask-Actions).made;
for @program -> $block {
  $block()
}
say [+] %mem.values;
