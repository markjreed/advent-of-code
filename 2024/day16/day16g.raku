#!/usr/bin/env raku
unit sub MAIN($input, $start-dir=1);
use Graph;

my \StepCost = 1;
my \TurnCost = 1000;

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
my @edges = gather for @vertices -> $key {
    my ($i,$j,$dir) = $key.split(',')».Int;
    for ($dir-1)%4, ($dir+1)%4 -> $d {
        my $neighbor = "$i,$j,$d";
        take { from => $key, to => $neighbor, weight => TurnCost };
    }
    my ($ni, $nj) = ($i,$j) Z+ @(@dirs[$dir]);
    if @map[$ni;$nj] (elem) ['.','S','E'] {
        take { from => $key, to => "$ni,$nj,$dir", weight => StepCost }
    }
}
my $graph = Graph.new;
$graph.add-edges(@edges);

sub cost(@path) {
    my $last;
    my $cost = 0;
    for @path -> $node {
        if $last {
            $cost += $graph.adjacency-list{$last}{$node};
        }
        $last = $node;
    }
    return $cost;
}

my @best = (Inf, []);
my $start = "$start-at,$start-dir";
for "$end-at," Z~ ^4 -> $finish {
    my @paths = $graph.find-path($start, $finish, count => Inf).sort({ cost($_) });
    my $cost = cost(@paths[0]);
    if $cost < @best[0] {
        @best = ($cost, @paths.grep: { cost($_) == $cost });
    }
}
say @best[0];
my %good-seats;
for @best[1] -> $path {
    for @$path -> $node {
        %good-seats{$node}=True;
    }
}
say +%good-seats;
