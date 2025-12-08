#!/usr/bin/env raku
enum Axis <X Y Z>;

class Point {
    has int $.x; 
    has int $.y;
    has int $.z;
    has Int $.circuit = Nil;

    multi method coordinate(Int $axis where 0 <= $axis < Axis.enums) {
        return [$.x,$.y,$.z][$axis];
    }

    multi method coordinate(Axis $axis) {
        return [$.x,$.y,$.z][+$axis];
    }

    method distance($other) {
        my $dx = abs($other.x - self.x);
        my $dy = abs($other.y - self.y);
        my $dz = abs($other.z - self.z);
        return sqrt($dx*$dx + $dy*$dy + $dz*$dz);
    }
}

class PointTree {
    has Point $.point;
    has Axis $.axis;
    has PointTree $.left = Nil;
    has PointTree $.right = Nil;

    method from-list(::?CLASS:U $class: Array[Point] $points, Int $depth = 0) {
        return Nil unless $points;
        my Axis $axis = Axis($depth % +Axis.enums);
        my @sorted of Point = $points.sort(*.coordinate($axis));
        my Int $mid = @sorted div 2;
        my Point $median = @sorted[$mid];
        my PointTree $left = $class.from-list(Array[Point].new(@sorted[0..$mid-1]), $depth+1);
        my PointTree $right = $class.from-list(Array[Point].new(@sorted[$mid+1..*]), $depth+1);
        $class.new(:point($median), :axis($axis), :left($left), :right($right));
    }
}

my $circuit = 0;
my @points of Point;
for lines».&{.split(',')».Int} -> ($x, $y, $z) {
    @points.push(Point.new: :$x, :$y, :$z);
}
my $tree = PointTree.from-list(@points);
say $tree.raku;
