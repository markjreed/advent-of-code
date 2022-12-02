#!/usr/bin/env raku
# read the data
my @rounds = $*ARGFILES.lines».&{.words.join: ''};

# Generate the list of potential matchups:
my @keys = «A B C» X~ «X Y Z»;

# And map them to their scores. See notes.txt file for derivation of the formulas.
my %part1 = @keys Z=>
    ( (1..3).map: -> \e { |(1..3).map: -> \h { (h - e + 1) % 3 * 3 + h } } );

my %part2 = @keys Z=>
    ( (1..3).map: -> \e { |(^3).map: -> \h { h*3 + (e + h + 1) % 3 + 1 } } );

say "Part 1: {[+] @rounds».&{%part1{$_}}}";
say "Part 2: {[+] @rounds».&{%part2{$_}}}";
