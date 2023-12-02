#!/usr/bin/env raku
unit sub MAIN($file);

my $total = 0;
for $file.IO.lines -> $line is copy {
  my $first = +($line ~~ /\d/);
  my $last = ~($line ~~ /\d<!before .*\d>/);
  my $value = 10 * $first + $last;
  $total += $value;
}
say $total;
