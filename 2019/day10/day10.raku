#!/usr/bin/env raku
unit sub MAIN($input);

my @map = $input.IO.lines».comb;

my @asteroids = gather for @map.kv -> $y, @row {
    for @row.kv -> $x, $cell {
        take ($x, $y) if $cell eq '#';
    }
}

my $most = 0;
my %first;
for @asteroids -> ($x1, $y1) {
    my $key = "$x1,$y1";
    for @asteroids -> ($x2, $y2) {
        next if $x1 == $x2 && $y1 == $y2;
        my ($dx, $dy) = ($x2 - $x1, $y2 - $y1);
        my $θ = atan2($dy, $dx) * 180 / π;
        my $d = sqrt($dx * $dx + $dy * $dy);
        if (%first{$key}:!exists) || (%first{$key}{$θ}:!exists) || %first{$key}{$θ} > $d {
            %first{$key}{$θ} = $d;
        }
    }
    my $count = +%first{$key};
    $most = $count if $count > $most;
}
say $most;


        
