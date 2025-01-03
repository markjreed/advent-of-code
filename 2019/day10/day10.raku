#!/usr/bin/env raku
unit sub MAIN($input);

my @map = $input.IO.lines».comb;

my @asteroids = gather for @map.kv -> $y, @row {
    for @row.kv -> $x, $cell {
        take ($x, $y) if $cell eq '#';
    }
}

# like atan2 but returns seconds of arc clockwise from up, assuming
# +x = right and +y = down: 0 - 1_295_999
sub dir($dy, $dx) {
    if $dx == 0 {
        return $dy < 0 ?? 0 !! 648_000;
    } elsif $dy == 0 {
        return $dx < 0 ?? 972_000 !! 324000
    } else {
        return floor( (π/2 - atan2(-$dy, $dx)) / π * 180 * 60 * 60) % 1_296_000;
    }
}

my $most = 0;
my $station;
my %direction;
for @asteroids -> ($x1, $y1) {
    my $key1 = "$x1,$y1";
    for @asteroids -> ($x2, $y2) {
        next if $x1 == $x2 && $y1 == $y2;
        my $key2 = "$x2,$y2";
        my ($dx, $dy) = ($x2 - $x1, $y2 - $y1);
        my $θ = dir($dy, $dx);
        my $d = sqrt($dx * $dx + $dy * $dy);
        %direction{$key1}{$θ}{$d} = $key2;
    }
    my $count = +%direction{$key1};
    if $count > $most {
        $most = $count;
        $station = $key1;
    }
}
# Greatest number of visible asteroids is $most from $station
say $most; # part 1

my %targets = %direction{$station};

my $destruction-sequence := gather while %targets {
    #say %targets.raku;
    for %targets.keys.sort(&infix:«<=>») -> $dir {
        if !+%targets{$dir} {
            %targets{$dir}:delete;
            next;
        }
        #print "direction $dir:";
        my $target-distance = %targets{$dir}.keys.sort(&infix:«<=>»)[0];
        #say %targets{$dir}{$target-distance};
        take %targets{$dir}{$target-distance}:delete;
    }
}
# Part 2: find the 200th asteroid vaporized and output 100*$x+$y";
my ($x,$y) = $destruction-sequence[199].split(',');
say 100 * $x + $y;
