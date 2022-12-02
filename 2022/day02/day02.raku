#!/usr/bin/env raku
# read the data
my @rounds = $*ARGFILES.lines».&{.words.join: ''};

# Potential matchups:
my @keys = «A B C» X~ «X Y Z»;

# Matchup scores for part 1:
# (elf - human % 3) is 0 for a draw, 1 if the elf wins, and 2 if the human wins;
# we leave 2's alone and swap 1's and 0's, then multiply by 3 to get the match score
# and add the value of the human's play to get the final score.
my %part1 = @keys Z=>
            (3 «*« ((1..3 X- 1..3) »%» 3)».&{$_ == 2 ?? $_ !! 1-$_ } Z+ |(1..3) xx 3);

say "Part 1:{[+] $@rounds».&{%part1{$_}}}";

# Matchup scores for part 2:
# In this case the human part is the match result; mutiply by 3 to get that score, then
# derive the play, which is (elf + human + 2)%3+1 = 1 for rock, 2 for paper, 3 for scissors
my %part2 = @keys Z=> (|(3 «*«^3) xx 3  Z+  ((0..2 X+ 0..2) »+» 2) »%» 3 »+» 1);

say "Part 2:{[+] $@rounds».&{%part2{$_}}}";
