#!/usr/bin/env raku
my (%valves, %edges);
for $*ARGFILES.lines {
  die "Unable to parse line '$_'" unless
    /^Valve \s+ (\S+) \s+ 'has flow rate=' (\d+) '; ' tunnels? \s+ leads? \s+ 'to valve's? \s+ (.*)$/;
    %valves{~$0} = +$1;
    %edges{$0} = $2.trans(','=>'').words;
}

# build a distance matrix
my @caves = (%edges.keys (|) %valves.keys).keys;
my %distance = @caves.map: * => %(@caves »=>» ∞);
for @caves -> $from {
  %distance{$from}{$from} = 0;
  for @(%edges{$from}) -> $to {
    %distance{$from}{$to} = %distance{$to}{$from} = 1;
  }
}
for @caves.clone -> $via {
  for @caves.clone -> $from {
    for @caves -> $to {
      %distance{$from}{$to} min= %distance{$from}{$via} + %distance{$via}{$to};
    }
  }
}

# we only care about non-broken valves
%valves = %(%valves.pairs.grep: *.value);
#say %valves;

my $at = 'AA';
my $time-left = 30;
say %valves.keys.map: { $_ => ($time-left - %distance{$at}{$_} - 1) * %valves{$_} };
#my $first = %valves.keys.max: { ($time-left - %distance{$at}{$_} - 1) * %valves{$_} };
#say "first=$first";


