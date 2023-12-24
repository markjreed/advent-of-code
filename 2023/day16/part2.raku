unit sub MAIN($input); 
use Day16;

my @map = $input.IO.lines».comb;
my $rows = +@map;
my $cols = +@map[0];

my $max = 0;
for ^$rows -> $i {
    my $left  = simulate-beam(@map, $i, 0,       0,  1);
    my $right = simulate-beam(@map, $i, $cols-1, 0, -1);
    $max = [$max, $left, $right].max;
}
for ^$cols -> $j {
    my $top    = simulate-beam(@map, 0,       $j,  1, 0);
    my $bottom = simulate-beam(@map, $rows-1, $j, -1, 0);
    $max = [$max, $top, $bottom].max;
}
say $max;
