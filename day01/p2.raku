#!/usr/bin/env raku
my @data = lines;
say (@data [Z<] @data.skip(3)).sum
