#!/usr/bin/env raku

# Read the input
my @lines = $*ARGFILES.lines;

# Find the line containing the stack numbers
my ($label-pos, @labels) = @lines.first({/\d/},:kv)».&{|.words};

# Everything above that is a picture of the starting config;
# parse out just the crate identifier letters
my @picture = @lines.head($label-pos)».&{.comb[1,5...*]};

# And everything below that (after a blank line) is move instructions;
# parse into a list of parameters for each move (count, source, and destination)
my @moves = @lines.tail(*-$label-pos-2)».&{.words[1,3...*]}

# Transpose the picture into an array of stacks
my @start = [Z](@picture)».grep(* ne ' ')».Array;

# Run the simulation twice, once for each part of the puzzle
for ^2 -> $part {
  # begin with a copy of the starting configuration
  my %stacks = @labels Z=> @start».clone;

  # perform the moves
  for @moves -> ($count, $from, $to) {
    if !$part {
      # part 1: shift one crate at a time
      %stacks{$to}.unshift: %stacks{$from}.shift for ^$count;
    } else {
      # part 2: shift N crates at a time
      %stacks{$to}.unshift: |%stacks{$from}.splice(0, +$count);
    }
  }

  # Print the result
  say "Part {$part+1}: {%stacks.sort».value»[0].join}";
}
