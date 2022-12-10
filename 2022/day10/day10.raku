#!/usr/bin/env raku
my @program = $*ARGFILES.lines».words;

my ($clock, $x) = 0, 1;
my %clocks = noop => 1, addx => 2;
my @x;

for @program -> ($instruction, $operand=(Any)) {
  for ^%clocks{$instruction} {
    @x[$clock++] = $x;
  }
  if $instruction eq 'addx' {
    $x += $operand
  }
}
@x[$clock] = $x;

say "Part 1: {[+] [20,60...220].map: { $_ * @x[$_-1] }}";

say "Part 2:";

for ^6 -> $i {
  for ^40 -> $j {
    my $x = @x[40*$i+$j];
    print  abs($j-$x) <= 1 ?? '#' !! '.';
  }
  say ''
}
