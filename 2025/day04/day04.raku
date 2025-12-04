my @grid = lines()».comb».Array;

my @removable = find-removable(@grid);
my ($part1, $part2) »=» +@removable;
while @removable {
    for @removable -> ($i, $j) {
        @grid[$i][$j] = '.';
    }
    @removable = find-removable(@grid);
    $part2 += +@removable;
}
say $part1;
say $part2;

sub find-removable(@grid) {
    my @result = [];
	for @grid.kv -> $i,@row {
	    for @row.kv -> $j,$cell {
	        if $cell eq '@' {
	            my $neighbors = 0;
	            for -1..1 -> $di {
	                my $ni = $i + $di;
	                next if $ni < 0 || $ni >= @grid;
	                for -1..1 -> $dj {
	                    next unless $di || $dj;
	                    my $nj = $j + $dj;
	                    next if $nj < 0 || $nj >= @row;
	                    $neighbors++ if @grid[$ni][$nj] eq '@';
	                }
	            }
                @result.push([$i,$j]) if $neighbors < 4;
	        }
	    }
	}
    return @result;
}
