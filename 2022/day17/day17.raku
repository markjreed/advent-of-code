#!/usr/bin/env raku
my @rocks = ((0,0),(1,0),(2,0),(3,0)),
            ((1,2),(0,1),(1,1),(2,1),(1,0)),
            ((2,2),(2,1),(0,0),(1,0),(2,0)),
            ((0,3),(0,2),(0,1),(0,0)),
            ((0,1),(1,1),(0,0),(1,0));
my @chamber = ['.' xx 7] xx 3;
my %deltas = '>' => 1, '<' => -1;

my @jets = $*ARGFILES.comb.map: { %deltas{$_} };
my $floor = 0;
my $rock = 0;
my $jet = 0;

# simulate until we have a complete cycle of rocks and jets

say "There are {+@rocks} rocks and {+@jets} jets, so the pattern will repeat after { +@rocks lcm +@jets } rocks
@chamber[0;0]='#';
.say for @chamber;
