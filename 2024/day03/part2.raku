#!/usr/bin/env raku
my $doing = True;
my $total = 0;
for slurp() ~~  m:g/('mul') '(' ( \d ** 1..3 ) ',' ( \d ** 1..3 ) ')' || ( 'do' "n't"? ) '()' / -> $/ {
    when ~$0 eq "do"    { $doing = True }
    when ~$0 eq "don't" { $doing = False }
    when ~$0 eq "mul"   { $total += $1 * $2 if $doing }
}
say $total;
