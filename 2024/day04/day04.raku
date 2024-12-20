#!/usr/bin/env raku
unit sub MAIN($input, :$colorize=False);
my @ws = $input.IO.lines()».comb».Array.Array;
my $height = +@ws;
my $width = +@ws[0];

my $xmas = 0;
my $x-mas = 0;

my (@copy1, @copy2);
if $colorize {
    @copy1 = @ws».clone».Array.clone.Array;
    @copy2 = @ws».clone».Array.clone.Array;
}

for @ws.kv -> $i, @row {
    for @row.kv -> $j, $letter {
        if $letter eq 'X' {
            for (-1,0, 1) -> $di {
                next unless 0 <= $i+3*$di < $height;
                for (-1,0, 1) -> $dj {
                    next unless 0 <= $j+3*$dj < $width;
                    next unless $di || $dj;
                    if @ws[$i+$di;$j+$dj]     eq 'M' && 
                       @ws[$i+2*$di;$j+2*$dj] eq 'A' && 
                       @ws[$i+3*$di;$j+3*$dj] eq 'S' {
                        $xmas++;
                        if $colorize {
                            for 0..3 -> $n {
                                @copy1[$i+$n*$di;$j+$n*$dj].=&{ "\e[31m{$_}\e[37m" };
                            }
                        }
                    }
                }
            }
        }

        if 1 <= $i < $height - 1 && 1 <= $j < $width - 1 && $letter eq 'A' {
            my $positive = @ws[$i+1;$j-1] ~ @ws[$i-1;$j+1];
            my $negative = @ws[$i-1;$j-1] ~ @ws[$i+1;$j+1];
            if ($positive eq 'MS' || $positive eq 'SM') &&
               ($negative eq 'MS' || $negative eq 'SM') {
                $x-mas++;
                if $colorize {
                    for -1..1 -> $d {
                        @copy2[$i+$d;$j+$d].=&{ "\e[32m{$_}\e[37m" };
                        @copy2[$i-$d;$j+$d].=&{ "\e[32m{$_}\e[37m" };
                    }
                }
            }
        }
    }
}
{ .join(' ').say for @copy1 } if $colorize;
say $xmas;
if $colorize {
    say '';
    .join(' ').say for @copy2;
}
say $x-mas;
