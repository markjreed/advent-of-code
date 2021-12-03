#!/usr/bin/env raku
my @data = $*ARGFILES.lines;
say (@data [Z<] @data.skip(3)).sum
