#!/usr/bin/env raku
unit sub MAIN($input, $steps=1000, :$verbose = False;);

constant ZERO = [0, 0, 0];

class Moon {
    has Int @.position;
    has Int @.velocity;
    sub vgist(@vector) {
        return "<x={@vector[0]}, y={@vector[1]}, z={@vector[2]}>";
    }
    multi method gist {
        return "pos={vgist($.position)}, vel={vgist($.velocity)}";
    }
    submethod BUILD(:@position, :@velocity = ZERO.clone) {
        @!position = @position;
        @!velocity = @velocity;
    }
}

my token number { '-' ? \d + }

my @moons;
for $input.IO.lines {
    if /^'<x=' <number> ',' \s* 'y=' <number> ',' \s* 'z=' <number> '>'$/ {
        @moons.push: Moon.new: :position($<number>».Int.Array);
    }
}

for ^$steps -> $step {
    if $verbose {
        say "After $step steps:";
        .say for @moons;
    }
    for @moons[0..*-2].kv -> $i, $this {
        for @moons[$i+1..*] -> $that {
            my @delta = (@($that.position) Z- @($this.position))».sign;
            $this.velocity = @($this.velocity) Z+ @delta;
            $that.velocity = @($that.velocity) Z- @delta;
        }
    }
    for @moons -> $this {
        $this.position = @($this.position) Z+ @($this.velocity);
    }
    say '' if $verbose;
}
if $verbose {
    say "After $steps steps:";
    .say for @moons;
}

say [+] gather for @moons { 
    .print if $verbose;
    my $pot = [+] @(.position)».abs; 
    my $kin = [+] @(.velocity)».abs;
    say ": pot: $pot; kin: $kin; total: { $pot * $kin }" if $verbose;
    take $pot * $kin;
}
