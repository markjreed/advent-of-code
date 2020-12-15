#!/usr/bin/env raku
unit sub MAIN($input-file, Int :$total = 2020, Int :$group-by = 2);

my @values = $input-file.IO.lines;

for @values.combinations($group-by).grep({ .sum == $total }) -> @p { 
  for «+ ×» -> $op {
    use MONKEY-SEE-NO-EVAL;
    say @p.join(" $op ") ~ " = " ~ EVAL "[$op] \@p";
  }
}
