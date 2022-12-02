#!/usr/bin/env raku
# read the data; transforms it into strings of the form 'AY', 'BX', etc.
my @rounds = $*ARGFILES.lines».&{ .words.join: ''};

# Generate the list of potential matchups 'AX', 'AY'...'CY', 'CZ'
my @keys = «A B C» X~ «X Y Z»;

# Create maps from each possible matchup to its score for each part
# (See notes.txt for derivation of the score formulas.)
my %part1 = @keys Z=>
    ( (1..3).map: -> \e { |(1..3).map: -> \h { (h - e + 1) % 3 * 3 + h } } );

my %part2 = @keys Z=>
    ( (1..3).map: -> \e { |(^3).map: -> \h { h*3 + (e + h + 1) % 3 + 1 } } );

# Add up the scores for each matchup in the actual data.
say "Part 1: {[+] %part1{@rounds}}";
say "Part 2: {[+] %part2{@rounds}}";
