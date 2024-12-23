#!/usr/bin/env raku
unit sub MAIN($input);

my %edges;
for $input.IO.lines.map(*.split('-')) -> ($a, $b) { 
    %edges{$a} = {} unless %edges{$a}:exists;
    %edges{$a}{$b} = True;
}

my %clusters;
for %edges.keys -> $a {
    for %edges.keys -> $b {
        next if $b eq $a;
        next unless %edges{$a}{$b} || %edges{$b}{$a};
        for %edges.keys -> $c {
            next if $c eq $a or $c eq $b;
            next unless (%edges{$a}{$c} || %edges{$c}{$a}) &&
                        (%edges{$b}{$c} || %edges{$c}{$b});
            my $key = [$a,$b,$c].sort.join(',');
            %clusters{$key} = True;
        }
    }
}

say + %clusters.keys.grep({ m/(^|',')t/ });
