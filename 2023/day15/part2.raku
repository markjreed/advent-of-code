#!/usr/bin/env raku
unit sub MAIN($input);

my @instructions = $input.IO.lines[0].split(',');

my @boxes = gather take [] for ^256;

for @instructions -> $instruction {
    next unless $instruction ~~ /^(<[a..z]>+)(<[-=]>)(\d*)/;
    my ($label, $op, $length) = $/».Str;
    my $box = compute-hash($label);
    given $op {
        when '-' {
            @boxes[$box] = @boxes[$box].grep({ $_[0] ne $label }).Array;
        }
        when '=' {
             if my $lens = @boxes[$box].grep({ $_[0] eq $label })[0] {
                 $lens[1] = $length;
             } else {
                 push @boxes[$box], [$label, $length];
             }
         }
         default {
             die "Unrecognized operations $op";
         }
    }
}
say focusing-power;

sub compute-hash($str) {
    my $cv = 0;
    for $str.comb».ord -> $asc {
        $cv = (17 * ($cv + $asc)) +& 0xff;
    }
    return $cv;
}

sub focusing-power() {
    my $power = 0;
    for @boxes.kv -> $i, $box {
        my $number = $i + 1;
        for @$box.kv -> $j, $lens {
            my $slot = $j + 1;
            $power += $number * $slot * $lens[1];
        }
    }
    return $power;
}

