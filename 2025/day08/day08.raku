#!/usr/bin/env raku
unit sub MAIN($filename, :d(:$depth)=10);

enum Axis <X Y Z>;

class Point {
    our $next-circuit = 0;
    has $.coords;
    has Int $.circuit is rw = $next-circuit++;;

    method x returns Int { $.coords[X] }
    method y returns Int { $.coords[Y] }
    method z returns Int { $.coords[Z] }

    our sub MAX-COORD() { 100_000; }
    our sub INFINITY() { INIT { 
        Point.new( coords => MAX-COORD() xx 3 )
    } }

    method distance($other) {
        my $dx = abs($other.x - self.x);
        my $dy = abs($other.y - self.y);
        my $dz = abs($other.z - self.z);
        return sqrt($dx*$dx + $dy*$dy + $dz*$dz);
    }

    method Str() { "({$.x},{$.y},{$.z})[$.circuit]"; }
    method gist() { self.Str() }
}

my @points of Point = $filename.IO.lines».&{.split(",")».Int}.map: { Point.new: coords => |$_ };
my @pairs = (@points X @points).grep(-> ($p, $q) { $p.coords lt $q.coords }).sort: -> ($p, $q) {
    $p.distance($q)
};
my @circuits = @points.map(*.circuit).unique;
for ^$depth {
    my ($p, $q) = @pairs.shift;
    next if $p.circuit == $q.circuit; # same circuit, nothing to do
    my $circuit = [$p.circuit, $q.circuit].min;
    my @members = @points.grep(*.circuit == $p.circuit|$q.circuit);
    for @members {
        .circuit = $circuit;
    }
    @circuits = @points.map(*.circuit).unique;
}
    
my @sizes = @circuits.map(-> $c { +@points.grep(*.circuit == $c) });
@sizes .= sort(-*);
say [*] @sizes[0..2];

my ($p, $q);
while @circuits > 1 {
    ($p, $q) = @pairs.shift;
    next if $p.circuit == $q.circuit; # same circuit, nothing to do
    my $circuit = [$p.circuit, $q.circuit].min;
    my @members = @points.grep(*.circuit == $p.circuit|$q.circuit);
    for @members {
        .circuit = $circuit;
    }
    @circuits = @points.map(*.circuit).unique;
}
say $p.x * $q.x;
