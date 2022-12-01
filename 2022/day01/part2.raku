#!/usr/bin/env raku
say $*ARGFILES.slurp.split("\n\n")».words».sum.sort[*-3..*].sum
