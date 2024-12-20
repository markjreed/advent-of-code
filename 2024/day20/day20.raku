#!/usr/bin/env raku
unit sub MAIN($input, :$thresholds=100, :$report=False);

my @thresholds;
if $thresholds ~~ /','/ {
    @thresholds = $thresholds.split(',')».Int;
} else {
    @thresholds = $thresholds xx 2;
}
    
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
say "With no cheating, the path is {+@path-1} picoseconds." if $report;

sub deltas($size) {
    gather for -$size .. $size -> $di {
        my $left = $size - abs($di);
        for -$left .. $left -> $dj {
            take ($di, $dj) if $di || $dj;
        }
    }
}
            
sub count-cheats($max-time, $threshold) {
    my @deltas = deltas($max-time);
    my %counts;

    for @path.clone.kv -> $n1, $s1 {
        my ($i1, $j1) = $s1.split(',');
        for  @deltas -> ($di, $dj) {
             my ($i2, $j2) = ($i1, $j1) Z+ ($di, $dj);
             if defined my $n2 = %pos{"$i2,$j2"} {
                 my $d = abs($di) + abs($dj);
                 my $savings = $n2 - $n1 - $d;
                 if $savings >= $threshold {
                     %counts{$savings}++;
                 }
             }
        }
    }
    return %counts;
}
my $count = 0;
for count-cheats(2, @thresholds[0]).pairs.sort(+*.key) {
    my ($k, $v) = .kv;
    say "There {$v != 1 ?? 'are' !! 'is'} $v cheat{$v != 1 ?? 's' !! ''} that save{$v == 1 ?? 's' !! ''} $k picosecond{$k != 1 ?? 's' !! ''}." if $report;
    $count += $v;
}
print "Part 1 total: " if $report;
say $count;
say '' if $report;
$count = 0;
for count-cheats(20, @thresholds[1]).pairs.sort(+*.key) {
    my ($k, $v) = .kv;
    say "There {$v != 1 ?? 'are' !! 'is'} $v cheat{$v != 1 ?? 's' !! ''} that save{$v == 1 ?? 's' !! ''} $k picosecond{$k != 1 ?? 's' !! ''}." if $report;
    $count += $v;
}
print "Part 2 total: " if $report;
say $count;
