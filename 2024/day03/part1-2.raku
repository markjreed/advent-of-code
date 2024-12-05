#!/usr/bin/env raku
my regex op { 
       ('mul') '(' ( \d ** 1..3 ) ',' ( \d ** 1..3 ) ')' 
    || ( 'do' "n't"? ) '()' 
}

my $doing = True;
my ($part1, $part2) »=» 0;
for slurp() ~~  m:g/ <op> / -> $/ {
    when $<op>[0] eq "do"    { $doing = True }
    when $<op>[0] eq "don't" { $doing = False }
    when $<op>[0] eq "mul"   { 
        my $product = $<op>[1] * $<op>[2];
        $part1 += $product;
        $part2 += $product if $doing;
    }
}
.say for $part1, $part2;
