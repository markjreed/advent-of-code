#!/usr/bin/env raku
unit sub MAIN($input, $start-dir=1);
use BinaryHeap;

my @map = $input.IO.lines».comb».Array.Array;

my ($start-at, $end-at);

# convert to graph. Vertices are [(i,j),facing]
my @occupiable = @map.kv.map(
    -> $i, @row {
        |@row.kv.map: -> $j, $cell { [$i,$j,$cell] } 
    }).grep(-> ($i,$j,$sym) { $start-at = "$i,$j" if $sym eq 'S'; $end-at = "$i,$j" if $sym eq 'E'; $sym (elem) ['.','S','E'] }).map: -> ($i,$j,$_) { [$i,$j] };

my @vertices = (@occupiable X, ^4).map: -> (($i,$j),$dir) { "$i,$j,$dir" };

# map from directions to coordinate deltas
my @dirs = ( (-1,0), (0,1), (1,0), (0,-1) );

# edges with cost
my %edges;
for @vertices -> $key {
    my ($i,$j,$dir) = $key.split(',')».Int;
    for ($dir-1)%4, ($dir+1)%4 -> $d {
        my $neighbor = "$i,$j,$d";
        %edges{$key}{$neighbor} = 1000;
    }
    my ($ni, $nj) = ($i,$j) Z+ @(@dirs[$dir]);
    if @map[$ni;$nj] (elem) ['.','S','E'] {
        %edges{$key}{"$ni,$nj,$dir"} = 1;
    }
}

my $start = "$start-at,$start-dir";
my %distances = @vertices »=>» Inf;
my @unvisited = @vertices.grep:{ $_ ne $start };
my BinaryHeap::MinHeap[{%distances{$^a} cmp %distances{$^b}}] $heap;
$heap.heapify(@unvisited);
while ?$heap { 
    print "{+@$heap} unvisited vertices left      \r";
    my $u = $heap.pop;
    last if %distances{$u} == Inf;
    for %edges{$u}.kv -> $v, $step {
        my $alt = %distances{$u} + $step;
        if $alt < %distances{$v} {
            %distances{$v} = $alt;
        }
    }
}
say '0 unvisited vertices left';
say ("$end-at," Z~ ^4).map({ %distances{$_} }).min;
