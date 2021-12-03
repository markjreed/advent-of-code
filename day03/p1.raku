#!/usr/bin/env raku
my $γ2 = ([Z+] $*ARGFILES.lines.map(*.comb.map(*.subst(0,-1)))).map({ +($_ > 0) }).join;
my $ε2 = $γ2.trans: '01' => '10';
my $γ = $γ2.parse-base(2);
my $ε = $ε2.parse-base(2);
my $power = $γ * $ε;
say "γ=$γ, ε=$ε, power=$power";
