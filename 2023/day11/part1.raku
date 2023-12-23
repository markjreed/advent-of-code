#!/usr/bin/env raku
unit sub MAIN($input, :$debug = False);

# expand rows as we collect them
my @grid = $input.IO.lines.map({ .say if $debug; /^'.'+$/ ?? |( $_, $_ ) !! $_ })».comb;

{ .say for @grid } if $debug;

# then go through and expand columns
my @empty-columns = gather for ^@grid[0] -> $j {
   my $column = (^@grid).map(-> $i { @grid[$i][$j] }).join;
   take $j if $column ~~ /^'.'*$/;
};

for @empty-columns.kv -> $n, $col {
    for @grid.kv -> $i, @row {
        my $j = $col + $n;
        @grid[$i] = |@row[0..^$j], |(@row[$j], @row[$j]), |@row[$j^..*];
    }
}
{ .say for @grid } if $debug;

my @galaxies = gather for @grid.kv -> $i, @row {
  for @row.kv -> $j, $cell {
     take [$i,$j] if $cell eq '#';
  }
}

say "Found {+@galaxies} galaxies." if $debug;

my $total = 0;
for ^@galaxies.end -> $g1 {
  my ($i1, $j1) = @galaxies[$g1];
  for $g1+1..^@galaxies -> $g2 {
    my ($i2, $j2) = @galaxies[$g2];
    $total += abs($i1-$i2) + abs($j1-$j2);
  }
}
print "Sum of shortest-path distances: " if $debug;
say $total;
