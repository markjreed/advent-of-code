#!/usr/bin/env raku
unit sub MAIN($input, :$expansion-factor=1_000_000, :$debug = False);

# track empty rows as we collect them
my @empty-rows;
my @grid = $input.IO.lines.kv.map(-> $i, $row { .say if $debug; @empty-rows.push($i) if $row ~~ /^'.'+$/; $row })».comb;

say "Empty rows: {@empty-rows}" if $debug;

{ .say for @grid } if $debug;

# then go through and expand columns
my @empty-columns = gather for ^@grid[0] -> $j {
   my $column = (^@grid).map(-> $i { @grid[$i][$j] }).join;
   take $j if $column ~~ /^'.'*$/;
};

say "Empty columns: {@empty-columns}" if $debug;

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
    $total += ($expansion-factor - 1) * @empty-rows.grep: { $i1 < $_ < $i2  || $i2 < $_ < $i1 };
    $total += ($expansion-factor - 1) * @empty-columns.grep: { $j1 < $_ < $j2  || $j2 < $_ < $j1 };
  }
}
print "Sum of shortest-path distances: " if $debug;
say $total;
