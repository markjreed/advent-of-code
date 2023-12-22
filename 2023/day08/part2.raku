unit sub MAIN($input);

my ($sequence, @nodes) = $input.IO.lines;

my %edges;
for @nodes -> $node {
  my ($label, $eq, $left, $right) = $node.words;
  next unless $eq && $eq eq '=';
  %edges{$label}«L» = $left.comb[1..*-2].join;
  %edges{$label}«R» = $right.comb[0..*-2].join;
}

my @sequence = $sequence.comb;
my @current = %edges.keys.grep: { /A$/ };
my @periods = @current.map: -> $current is copy {
  my $steps = 0;
  while $current !~~ /Z$/ {
    $current = %edges{$current}{@sequence[$steps % @sequence]};
    $steps++;
  }
  $steps;
};

say [lcm] @periods;
