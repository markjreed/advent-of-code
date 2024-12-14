#!/usr/bin/env raku
unit sub MAIN($filename);
# Button A: X+94, Y+34
# Button B: X+22, Y+67
# Prize: X=8400, Y=5400
#

my @mat;
my $machine = 0;
my ($part1, $part2) »=» 0;
my ($ax, $ay, $bx, $by, $px, $py);
for $filename.IO.lines {
    if m/^'Button A: X+' (\d+) ', Y+' (\d+)/ {
        $machine++;
        ($ax, $ay) = +$0, +$1;
    } elsif m/^'Button B: X+' (\d+) ', Y+' (\d+)/ {
        ($bx, $by) = +$0, +$1;
    } elsif m/^'Prize: X=' (\d+) ', Y=' (\d+)/ {
        ($px, $py) = +$0, +$1;
        my $a = ($px * $by - $py * $bx) / ($ax * $by - $ay * $bx);
        my $b = ($ax * $py - $ay * $px) / ($ax * $by - $ay * $bx);
        if $a == Int($a) && $b == Int($b) {
            $part1 += 3 * $a + $b;
        }
        ($px, $py) »+=» 10000000000000;
        $a = ($px * $by - $py * $bx) / ($ax * $by - $ay * $bx);
        $b = ($ax * $py - $ay * $px) / ($ax * $by - $ay * $bx);
        if $a == Int($a) && $b == Int($b) {
            $part2 += 3 * $a + $b;
        }
    }
}
say $part1;
say $part2;
