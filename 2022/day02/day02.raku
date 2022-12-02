#!/usr/bin/env raku
# read the data
my @rounds = $*ARGFILES.lines».&{.words.join: ''};

# Potential matchups:
my @keys = «A B C» X~ «X Y Z»;

# Assume rock=1, paper=2, scissors=3 throughout
# Matchup scores for part 1:
# (human - elf + 1) % 3 is 0 if the elf wins, 1 if it's a draw, and 2 if the human wins;
# we just multiply by 3 to get the match score and add the value of the human's
# play to get the final score.
my %part1 = @keys Z=> (3 «*« ((-1 «*« (1..3 X- 1..3) »+» 1) »%» 3) Z+ |(1..3) xx 3);

say "Part 1:{[+] @rounds».&{%part1{$_}}}";

# Matchup scores for part 2:
# In this case the human part is the match result, so just mutiply by 3 to get that score.
# Then derive the play, which is (elf + human) % 3 + 1
my %part2 = @keys Z=> (|(3 «*«^3) xx 3  Z+  (1..3 X+ 1..3)  »%» 3 »+» 1);

say "Part 2:{[+] @rounds».&{%part2{$_}}}";
