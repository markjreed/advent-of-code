#!/usr/bin/env raku
unit sub MAIN($input-file);

my ($mask, @mem);

sub apply-mask($mask, $value) {
  my @mask-bits = $mask.comb;
  my @result-bits = sprintf('%036b', $value).comb;
  for ^$@mask-bits -> $i {
    @result-bits[$i] = @mask-bits[$i] unless @mask-bits[$i] eq 'X';
  }
  return :2( [~] @result-bits )
}

grammar Bitmask {
  token TOP { <instruction>+ %% "\n" }
  token instruction { <set-mask> | <store-value> | <empty-line> }
  token empty-line { "" }
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
    if $<empty-line> {
      make {;};
    } else {
      make $<set-mask> ?? $<set-mask>.made !! $<store-value>.made 
    }
  }
  method set-mask($/) {
    make { $mask = ~ $<mask-value> }
  }
  method store-value($/) {
    make { @mem[$<index>.made] = apply-mask($mask, $<value>.made); };
  }
  method index($/) { make $<number>.made; }
  method value($/) { make $<number>.made; }
  method number($/) { make +$/; }
}

my @program = Bitmask.parse($input-file.IO.slurp, actions => Bitmask-Actions).made;
for @program -> $block {
  $block()
}
say [+] @mem;
