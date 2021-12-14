#!/usr/bin/env raku
my ($template, @rules) = slurp.split("\n", :skip-empty);

# keep a count of both the individual elements and the pairs
my %state;
%state«elements» = {};
for $template.comb -> $el {
  %state«elements»{$el}++;
}

for $template.comb.rotor(2=>-1)».join -> $pair {
  %state«pairs»{$pair}++;
}

# rules replace one pair with two different pairs and increment one element
my %rules;
for @rules.map({ .split(/\s+/)[0,2] }) -> ($from, $to) {
  my ($l, $r) = $from.comb;
  %rules{$from} = ( $to, "$l$to", "$to$r" );
}

# apply the rules once and return the new state
sub step(%state) {
  my %new = %state».clone;
  for %rules.kv -> $from, ($el, *@to) {
    next unless my $count = %state«pairs»{$from};
    %new«elements»{$el} += $count;
    %new«pairs»{$from} -= $count;
    %new«pairs»{$_} += $count for @to;
  }
  return %new;
}

# return the puzzle answer: difference between the occurrences of the most and
# least frequent elements
sub count(%state) {
   [-] %state«elements».values.List.&{ .max, .min };
}

# Iterate the requested number of steps
for ^40 -> $i {
  say count(%state) if $i==10; # output part 1 answer
  %state = step(%state);
}
say count(%state); # output part 2 answer
