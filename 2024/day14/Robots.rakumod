unit class Robots;

class Robot {
    has @.position;
    has @.velocity;
    has $.width;
    has $.height;
    method update($seconds=1) {
        @!position Z+= $seconds «*« @!velocity;
        @!position[0] %= $!width;
        @!position[1] %= $!height;
    }
}

has $.width;
has $.height;
has @.robots;
has @!cell-counts;
has @!quadrant-counts;
has $!counts-valid = False;;

method !update-counts {
    return if $!counts-valid;
    @!cell-counts = (^$!height).map( { (0 xx $!width).Array; } ).Array;
    @!quadrant-counts = (0 xx 4).Array;
    my ($hw, $hh);
    $hw = $!width div 2;
    $hh = $!height div 2;
    for @!robots -> $robot {
       my ($x,$y) = $robot.position;
       @!cell-counts[$y][$x]++;
       if ($!width %% 2 || $x != $hw) && ($!height %% 2 || $y != $hh) {
           my $h1 = ?!$!height %% 2;
           my $w1 = ?!$!width %% 2;
           my $quadrant = 2 * ($y div ($hh + $h1)) + ($x div ($hw + $w1));
           @!quadrant-counts[$quadrant]++;
       }
    }
    $!counts-valid = True;
}

method render {
    self!update-counts;
    my $delim = @!cell-counts».grep(*>9).grep(+*)  ?? ' ' !! '';
    for @!cell-counts -> @row {
        say @row.map({ $_ || '.' } ).join($delim);
    }
}

method add-robot($px, $py, $vx, $vy) {
    @!robots.push: Robot.new(:position($px,$py), :velocity($vx,$vy), :width($!width), :height($!height));
    $!counts-valid = False;
}

method update($seconds=1) {
    for @!robots {
       .update($seconds);
    }
    $!counts-valid = False;
}

method safety-factor() {
    self!update-counts;
    return [*] @!quadrant-counts;
}

method get-count($x, $y) {
    self!update-counts;
    return @!cell-counts[$y;$x];
}

method save-frame($filename) {
    self!update-counts;
    given my $fh = open($filename, :w) {
        $fh.say: 'P1';
        $fh.say: "$!width $!height";
        for ^$!height -> $y {
            for ^$!width -> $x {
                $fh.print(' ') if $x > 0;
                $fh.print(self.get-count($x,$y) ?? 1 !! 0);
            }
            $fh.say: '';
        }
    }
}
