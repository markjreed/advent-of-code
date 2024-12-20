#!/usr/bin/env raku
unit sub MAIN($input, $threshold=100);

my @racetrack = $input.IO.lines».comb;
my $height = +@racetrack;
my $width = +@racetrack[0];

my $start = (^$height X, ^$width).first: -> ($i, $j) { @racetrack[$i;$j] eq 'S' };

my @path = [ $start.join(',') ];
my $part1 = 0;

my ($i,$j) = @$start;
my %pos;
while @racetrack[$i;$j] ne 'E' {
    #print "{+@path}\r";
    for ((-1,0),(0,1),(1,0),(0,-1)) -> ($di, $dj) {
        my ($ni, $nj) = ($i, $j) Z+ ($di, $dj);
        if "$ni,$nj" !(elem) @path && 0 <= $ni < $height && 0 <= $nj < $width && @racetrack[$ni;$nj] ∊ ('.','E') {
            ($i, $j) = $ni, $nj;
            my $key = "$i,$j";
            my $pos = +@path;
            @path.push: $key;
            %pos{$key} = $pos;
        }
    }
}

my @deltas = [         (-2,  0),
             (-1, -1), (-1,  0), (-1,  1), 
    (0, -2), ( 0, -1),           ( 0,  1), ( 0,  2), 
             (-1,  1), ( 0,  1), ( 1,  1), 
                       ( 2,  0) 
];

for @path.clone.kv -> $n1, $s1 {
    my ($i1, $j1) = $s1.split(',');
    for  @deltas -> ($di, $dj) {
         my ($i2, $j2) = ($i1, $j1) Z+ ($di, $dj);
         if defined my $n2 = %pos{"$i2,$j2"} {
             my $d = abs($di) + abs($dj);
             $part1++ if $d <= $n2 - $n1 - $threshold;
         }
    }
}

say $part1;
