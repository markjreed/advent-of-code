unit module Day16;

sub simulate-beam(@map, $i, $j, $di, $dj) is export {
    my $rows = +@map;
    my $cols = +@map[0];
    my @beams = [[$i,$j, $di, $dj],];
    my @energized = gather for ^$rows {
        take [ gather for ^$cols { take 0 } ]
    };

    my %seen;
    while @beams {
        for @beams.cache.kv -> $b, $beam {
            my ($i, $j, $di, $dj) = @$beam;
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
