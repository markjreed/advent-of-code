#!/usr/bin/env raku
unit sub MAIN($filename);
# Button A: X+94, Y+34
# Button B: X+22, Y+67
# Prize: X=8400, Y=5400
#

my @mat;
my $machine = 0;
my $total = 0;
for $filename.IO.lines {
    if m/^'Button A: X+' (\d+) ', Y+' (\d+)/ {
        $machine++;
        @mat = [[+$0, 0, 0],[+$1, 0, 0]];
    } elsif m/^'Button B: X+' (\d+) ', Y+' (\d+)/ {
        @mat[0;1] = +$0;
        @mat[1;1] = +$1;
    } elsif m/^'Prize: X=' (\d+) ', Y=' (\d+)/ {
        @mat[0;2] = +$0;
        @mat[1;2] = +$1;
        my @x = solve(@mat);
        unless @x.grep: { $_ != Int($_) }  {
            $total += [+] @(@x) Z* (3,1);
        }
    }
}
say $total;

sub solve(@a is copy) {
    my $n = 2;
    my @x;
    for ^($n-1) -> $k {
        for ($k+1)..($n-1)  -> $i {
            @a[$i;$k] /= @a[$k;$k];
            for ($k+1)..($n-1) -> $j {
                @a[$i;$j] -= @a[$i;$k]*@a[$k;$j];
            }
        }
    }
    for ^($n-1) -> $k {
        for ($k+1)..($n-1) -> $i {
            @a[$i;2] -= @a[$i;$k] * @a[$k;2];
        }
    }
    for ($n-1) ... 0 -> $i {
        my $s = @a[$i;2];
        if $i < $n {
            for ($i+1)..$n-1 -> $j {
                $s -= @a[$i;$j] * @x[$j];
            }
        }
        @x[$i] = $s / @a[$i;$i];
    }
    return @x;
}
