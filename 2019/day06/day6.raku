#!/usr/bin/env raku
unit sub MAIN($input);

my %orbits;
for $input.IO.lines {
    if / (.*) ')' (.*) / {
        %orbits{$1} = ~$0;
    }
}
my $orbits = 0;
for %orbits.keys -> $obj is copy {
    while %orbits{$obj}:exists {
        $orbits += 1;
        $obj = %orbits{$obj};
    }
}
say $orbits; # part 1

my (%edges, %distance);
for %orbits.kv -> $sat, $prim {
    %edges{$sat}{$prim} = 1;
    %edges{$prim}{$sat} = 1;
    %distance{$sat} = Inf;
    %distance{$prim} = Inf;
}
my $from = %orbits<YOU>;
my $to = %orbits<SAN>;
my $to-visit = SetHash.new(%orbits.keys);
$to-visit.unset(«YOU SAN»);
%distance{$from} = 0;
while $to-visit {
    my $node = $to-visit.keys.min({ %distance{$_} });
    $to-visit.unset($node);
    last if %distance{$node} == Inf;
    for %edges{$node}.kv -> $neighbor, $dist {
        my $alt = %distance{$node} + $dist;
        %distance{$neighbor} = $alt if $alt < %distance{$neighbor};
    }
}
say %distance{$to};
