#!/usr/bin/env raku
for lines() {
    my ($x, $y, $d) = 0, 0, 0;
    my @d = [(0,-1),(1,0),(0,1),(-1,0)];
    my ($part2, %visited);
    for .words {
        die "Bad input '$_'\n" unless m/^ (<[LR]>)(\d+)','?$/;
        my ($dir, $count) = @$/;
        if $dir eq 'L' {
            $d = ($d - 1) % @d;
        } else { 
            $d = ($d + 1) % @d;
        }
        for ^$count {
            $x += @d[$d][0];
            $y += @d[$d][1];
            my $key = "$x,$y";
            if !$part2 && %visited{$key} {
                $part2 = abs($x) + abs($y);
            }
            %visited{$key} = True;
        }
    }
    say abs($x)+abs($y);
    say $part2;
}
