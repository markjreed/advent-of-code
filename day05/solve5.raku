#!/usr/bin/env raku
given [ $*ARGFILES.lines.map: { :2(TR/FBLR/0101/) } ] {
  say "max: " ~ .max;
  say "missing: " ~ (.minmax ∖ $_)
}
