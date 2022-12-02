#!/usr/bin/env raku
my %part1 = ((«A B C» X~ «X Y Z») Z
             ((1..3 X- 1..3) »%» 3)».&{$_ == 2 ?? $_ !! 1-$_} »*» 3 »+» ((1..3) xx 3).flat
            ).flat;

my @rounds = $*ARGFILES.lines».&{.words.join: ''};
say "Part 1:{[+] $@rounds».&{%part1{$_}}}";

my %part2 = ((«A B C» X~ «X Y Z») Z (3,4,8,1,5,9,2,6,7)).flat;
say "Part 2:{[+] $@rounds».&{%part2{$_}}}";
