#!/usr/bin/env raku
use MONKEY-TYPING;
augment class Seq {
  multi method window(Int:D $size) {
    gather {
      for (^(self.elems - $size + 1)) -> $i {
        take self[$i .. $i + $size - 1]
      }
    }
  }
};
my @data = $*ARGFILES.lines;
say @data.Seq.window(3).map(*.sum).window(2).map({ [<]($_) }).sum;
