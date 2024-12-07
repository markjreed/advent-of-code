#!/usr/bin/env raku
my ($part1, $part2) »=» 0;
for lines() -> $line {
    my ($goal, $components) = $line.split(':')».words;
    my $slots = @$components - 1;
    $goal = $goal[0];
    my ($possible1, $possible2) »=» False;
    PATTERN: for ^3**$slots -> $i {
        my @copy = @$components;
        my $trial = @copy.shift;
        my $eqn = "$goal = $trial";
        my $possible := $possible1;
        for "\%0{$slots}s".sprintf($i.base(3)).comb -> $trit {
            my $next = @copy.shift;
            if $trit eq '0' {
                $eqn ~= ' + ';
                $trial += $next;
            } elsif $trit eq '1' {
                $eqn ~= ' * ';
                $trial *= $next;
            } else {
                $eqn ~= ' || ';
                $possible := $possible2;
                $trial ~= $next;
            }
            $eqn ~= $next;
        }
        if +$trial == +$goal {
            $possible = True;
        }
    }
    $part1 += $goal if $possible1;
    $part2 += $goal if $possible1 || $possible2;
}
say $part1;
say $part2;
