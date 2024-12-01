#!/usr/bin/env raku
my ($list1, $list2) = [Z] lines».words;
my %histo;
for @$list2 -> $num { %histo{$num}++ }; 
my $sum = 0;
for @$list1 -> $num {
    $sum += $num * (%histo{$num} // 0);
}
say $sum;
