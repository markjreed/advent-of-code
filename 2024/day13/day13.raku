#!/usr/bin/env raku
unit sub MAIN($filename);
# Button A: X+94, Y+34
# Button B: X+22, Y+67
# Prize: X=8400, Y=5400
#

my @mat;
for $filename.IO.lines {
    if m/^'Button A: X+' (\d+) ', Y+' (\d+)/ {
        @mat = [[+$0, 0, 0],[+$1, 0, 0]];
    } elsif m/^'Button B: X+' (\d+) ', Y+' (\d+)/ {
        @mat[0;1] = +$0;
        @mat[1;1] = +$1;
    } elsif m/^'Prize: X=' (\d+) ', Y=' (\d+)/ {
        @mat[0;2] = -+$0;
        @mat[1;2] = -+$1;
        say "Solving {@mat.raku}";
        my $s = solve(@mat);
        say $s.raku;
    }
}

sub solve(@m) {
   say "on entry, m = {@m.raku}";
   for @m.kv -> $i, @row {
       my $pivot = @row.first(* != 0,  :k);
       if $pivot != $i {
           (@m[$i], @m[$pivot]) = @m[$pivot],@m[$i];
       }
       my $value = @row[$pivot];
       say "m[$i] ({@row.raku}), pivot=m[$i][$pivot]=$value";
       @row »/=» $value;
       say "normalized: {@row.raku} (m[$i] = {@m[$i].raku})";
       for $i+1..^@m -> $j {
           my $f = @m[$j][$pivot] / @row[$pivot];
          say "m[$j] = @m[$j], m[$j][$pivot] = {@m[$j][$pivot]}, factor = $f";
          say "subtracting f x row = {$f «*« @row}";
          @(@m[$j]) Z-= @($f «*« @row);
          say "m[$j] is now {@m[$j]}";
       }
   }

   my @solution;
   for (@m-1) ... 0 -> $i {
       my $sum = 0;
       if $i+1 < @m {
           for ($i+1) ..^ @m -> $j {
                say "i=$i, j=$j";
               $sum += @m[$i][$j] * @solution[$j];
           }
       }
       @solution.unshift( @m[$i][*-1] - $sum / @m[$i][$i] );
   }
   return  @solution;
}

sub solve2(@m) {
    my ($h, $k) »=» 0;
    my ($m, $n) = +@m, +@m[0];
    while $h < $m && $k < $n {
        my $i_max = max(@m»[$k]».abs, :k)[0];
        if @m[$i_max;$k] == 0 {
            $k += 1;
        } else {
            if $i_max != $h {
                (@m[$h], @m[$i_max]) = @m[$i_max], @m[$h];
            }
            for $h+1 ..^ $m -> $i {
                my $f = @m[$i; $k] / @m[$h; $k];
                @m[$i;$k] = 0;
                for $k+1 ..^ $n -> $j {
                    @m[$i;$j] -= $f * @m[$h;$j]
                }
            }
            $k += 1;
            $h += 1;
        }
    }
    return @m;
}
            

