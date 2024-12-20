#!/usr/bin/env raku
unit sub MAIN($input, :$threshold=100);

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

sub deltas($size) {
    gather for -$size .. $size -> $di {
        my $left = $size - abs($di);
        for -$left .. $left -> $dj {
            take ($di, $dj) if $di || $dj;
        }
    }
}
            
sub count-cheats($max-time) {
    my @deltas = deltas($max-time);
    my $count = 0;

    for @path.clone.kv -> $n1, $s1 {
        my ($i1, $j1) = $s1.split(',');
        for  @deltas -> ($di, $dj) {
             my ($i2, $j2) = ($i1, $j1) Z+ ($di, $dj);
             if defined my $n2 = %pos{"$i2,$j2"} {
                 my $d = abs($di) + abs($dj);
                 $count++ if $d <= $n2 - $n1 - $threshold;
             }
        }
    }
    return $count;
}

say count-cheats(2);
say count-cheats(20);
