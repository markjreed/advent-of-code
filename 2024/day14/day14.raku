#!/usr/bin/env raku
use v6.e.PREVIEW;
unit sub MAIN($input, $width=101, $height=103);

class Robot {
    has @.position;
    has @.velocity;
    method update($seconds=1) {
        @!position Z+= $seconds «*« @!velocity;
        @!position[0] %= $width;
        @!position[1] %= $height;
    }
}

class Map {
     has $.width;
     has $.height;
     has @.robots;
     has @!cell-counts;
     has @!quadrant-counts;
     has $!counts-valid = False;;
     method !update-counts {
         return if $!counts-valid;
         @!cell-counts = (^$height).map( { (0 xx $width).Array; } ).Array;
         @!quadrant-counts = (0 xx 4).Array;
         my ($hw, $hh);
         $hw = $width div 2 unless $width %% 2;
         $hh = $height div 2 unless $height %% 2;
         for @!robots -> $robot {
            my ($x,$y) = $robot.position;
            @!cell-counts[$y][$x]++;
            if $x != $hw && $y != $hh {
                my $quadrant = 2 * ($y div ($hh + 1)) + ($x div ($hw + 1));
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
         @!robots.push: Robot.new(:position($px,$py), :velocity($vx,$vy));
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
}

my $map = Map.new(:width($width), :height($height));
for $input.IO.lines -> $line {
    my ($px, $py, $vx, $vy) = ($line ~~ m:g/ '-'? \d + /)».Int;
    $map.add-robot($px, $py, $vx, $vy);
}

$map.update(100);
say $map.safety-factor;
