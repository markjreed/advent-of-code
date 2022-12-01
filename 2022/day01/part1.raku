#!/usr/bin/env raku
say $*ARGFILES.slurp.split("\n\n")».words».sum.max
