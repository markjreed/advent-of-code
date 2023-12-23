#!/usr/bin/env raku
unit sub MAIN($input);
use Part2;

my $total = 0;
for $input.IO.lines {
  my ($pattern, $groups) = .words;
  my $unfolded-pattern = ($pattern xx 5).join('?');
  my $unfolded-groups = ($groups xx 5).join(',');
  my $solutions = count-solutions($unfolded-pattern,
                                  $unfolded-groups);
  $total += $solutions;
}
say $total;
