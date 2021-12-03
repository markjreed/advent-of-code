#!/usr/bin/env raku
my @report = $*ARGFILES.lines;
my $half = @report / 2;
my @γ = ([Z+] @report.map(*.comb)).map({ +($_ > $half) });
my @ε = @γ.map: 1-*;
my $γ = @γ.join.parse-base(2);
my $ε = @ε.join.parse-base(2);
my $power = $γ * $ε;
say "γ=$γ, ε=$ε, power=$power";
