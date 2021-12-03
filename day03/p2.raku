#!/usr/bin/env raku
my @report = $*ARGFILES.lines;
my $width = @report[0].chars;
my $lfr = 1;
for ^2 -> $i {
  my @candidates = @report;
  for ^$width -> $j {
    my $zeroes = +@candidates.grep: {.substr($j,1) == 0};
    my $ones   = @candidates - $zeroes;
    my $criterion = $zeroes > $ones ?? $i !! 1 - $i;
    @candidates .= grep: { .substr($j,1) == $criterion };
    last if @candidates == 1;
  }
  $lfr *= @candidates[0].parse-base(2);
}
say "life support rating = $lfr";
