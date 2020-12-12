unit module Solve12;

class Heading  is export {
  has $.degrees;
  method radians {
    (90 - $!degrees)/180.0 * π;
  }
}

multi sub infix:<+>(Heading $lhs, Numeric $rhs) is export {
   Heading.new(degrees => $lhs.degrees + $rhs);
}

class Waypoint is export {
  has $.x;
  has $.y;

  method bearing  { Heading.new(degrees => 90-(atan2($!y,$!x)/π*180)); }
  method distance { sqrt($!x * $!x + $!y * $!y) }

  method N($units)   { $!y += $units; }
  method S($units)   { $.N(-$units); }
  method E($units)   { $!x += $units; }
  method W($units)   { $.E(-$units); }
  method L($degrees) { $.R(-$degrees); }

  method R(Numeric $degrees) {
    # remember starting values
    my ($r, $theta) = $.distance, $.bearing;
    $theta += $degrees;
    $!x = $r * cos($theta.radians);
    $!y = $r * sin($theta.radians);
  }
}
