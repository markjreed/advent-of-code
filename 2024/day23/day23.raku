#!/usr/bin/env raku
unit sub MAIN($input);

my %edges;
for $input.IO.lines.map(*.split('-')) -> ($a, $b) { 
    %edges{$a} = {} unless %edges{$a}:exists;
    %edges{$a}{$b} = True;
    %edges{$b}{$a} = True;
}

my %clusters;
for %edges.keys -> $a {
    for %edges.keys -> $b {
        next if $b eq $a;
        next unless %edges{$a}{$b};
        for %edges.keys -> $c {
            next if $c eq $a or $c eq $b;
            next unless %edges{$a}{$c} && %edges{$b}{$c};
            my $key = [$a,$b,$c].sort.join(',');
            %clusters{$key} = True;
        }
    }
}

say +%clusters.keys.grep({ m/(^|',')t/ });
my @max-cluster;
sub BronKerbosch1($R is copy, $P is copy, $X is copy) {
    if !$P && !$X {
        if +$R > @max-cluster {
            @max-cluster = $R.keys.Array;
        }
    }
    for $P.keys -> $v {
        my $V = SetHash.new($v);
        my $N = SetHash.new(%edges{$v}.keys);
        BronKerbosch1($R ∪ $V, $P ∩ $N, $X ∩ $N);
        $P = $P ∖ $V;
        $X = $X ∪ $V;
    }
}

BronKerbosch1(SetHash.new, SetHash.new(%edges.keys), SetHash.new);
say "largest cluster has {+@max-cluster} nodes: {@max-cluster.sort.join(',')}";
