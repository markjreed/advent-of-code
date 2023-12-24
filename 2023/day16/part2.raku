unit sub MAIN($input); 

my @map = $input.IO.lines».comb;
my $rows = +@map;
my $cols = +@map[0];

my $max = 0;
for ^$rows -> $i {
    my $left  = simulate-beam($i, 0,       0,  1);
    my $right = simulate-beam($i, $cols-1, 0, -1);
    $max = [$max, $left, $right].max;
}
for ^$cols -> $j {
    my $top   = simulate-beam(0,       $j,  1, 0);
    my $bottom = simulate-beam($rows-1, $j, -1, 0);
    $max = [$max, $top, $bottom].max;
}
say $max;

sub simulate-beam($i, $j, $di, $dj) {
    my @beams = [[$i,$j, $di, $dj],];
    my @energized = gather for ^$rows {
        take [ gather for ^$cols { take 0 } ]
    };

    my %seen;
    while @beams {
        for @beams.cache.kv -> $b, $beam {
            my ($i, $j, $di, $dj) = @$beam;
            my $key = $beam.join(',');
            if %seen{$beam} {
                @beams.splice($b, 1);
                next;
            }
            %seen{$beam} = True;
            if $i < 0 || $i >= @map || $j < 0 || $j >= @map[$i] {
                @beams.splice($b, 1);
                next;
            }
            @energized[$i][$j] = 1;
            given @map[$i][$j]  {
                when '.' {
                    @beams[$b] = [ $i+$di, $j+$dj, $di, $dj ];
                    next;
                }
                when '/' {
                    ($di, $dj) = -$dj, -$di;
                    @beams[$b] = [ $i+$di, $j+$dj, $di, $dj ];
                    next;
                }
                when '\\' {
                    ($di, $dj) = $dj, $di;
                    @beams[$b] = [ $i+$di, $j+$dj, $di, $dj ];
                    next;
                }
                when '|' {
                    if $dj == 0 {
                        @beams[$b] = [ $i+$di, $j+$dj, $di, $dj ];
                        next;
                    }
                    @beams[$b] = [ $i-1, $j, -1, 0 ];
                    @beams.push( [ $i+1, $j,  1, 0 ] );
                 }
                when '-' {
                    if $di == 0 {
                        @beams[$b] = [ $i+$di, $j+$dj, $di, $dj ];
                        next;
                    }
                    @beams[$b] = [ $i, $j-1,  0, -1 ];
                    @beams.push( [ $i, $j+1,  0,  1 ] );
                 }
             }
         }
    }
    return @energized».sum.sum;
}
