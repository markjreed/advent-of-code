#!/usr/bin/env raku
my @data = $*ARGFILES.lines;

# Find the line containing the stack numbers
my $labels = @data.first({/\d/},:k);

# Everything above that is a picture of the starting config
my @pic = @data.head($labels);

# Parse the picture into a usable form
my @start = [Z](@pic».&{.comb[1,5...*]})».grep(* ne ' ')».Array;

for 1..2 -> $part {
  # begin sim with copy of starting configuration
  my %stacks = @data[$labels].words Z=> @start».clone;

  # perform the moves
  for @data.tail(*-($labels+2)) {
    die "Illegal move '$_'" 
      unless /move \s+ (\d+) \s+ from \s+ (\d+) \s+ to \s+ (\d+)/;
    if $part == 1 {
      %stacks{$2}.unshift: %stacks{$1}.shift for ^$0;
    } else {
      %stacks{$2}.unshift: |%stacks{$1}.splice(0, +$0);
    }
  }
  say "Part $part:{%stacks.sort».value»[0]».trans(«[ ]» X=> '').join}";
}
