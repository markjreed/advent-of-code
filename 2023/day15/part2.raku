#!/usr/bin/env raku
unit sub MAIN($input);
use Day15;

my @instructions = $input.IO.lines[0].split(',');

my Array() @boxes = gather take [] for ^256;

for @instructions -> $instruction {
    next unless $instruction ~~ /^(<[a..z]>+)(<[-=]>)(\d*)/;
    my ($label, $op, $length) = $/».Str;
    my $box = compute-hash($label);
    given $op {
        when '-' {
            @boxes[$box] .= grep({ .key ne $label });
        }
        when '=' {
             if my @lenses = @boxes[$box].grep({ .key eq $label }) {
                 @lenses[0].value = $length;
             } else {
                 push @boxes[$box], $label => $length;
             }
         }
         default {
             die "Unrecognized operations $op";
         }
    }
}
say focusing-power(@boxes);
