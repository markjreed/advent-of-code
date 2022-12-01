unit sub MAIN($input-file, :$start-heading=90);
use lib '.';
use Solve12;

my ($x,$y) = (0,0);
my $wp = Waypoint.new(:10x, :1y);
for $input-file.IO.lines -> $line {
   my ($op, $arg) = @( $line ~~ / (<[NSEWLRF]>) (\d+) / );
   given ~$op {
     when 'N' { $wp.N(+$arg); }
     when 'S' { $wp.S(+$arg); }
     when 'E' { $wp.E(+$arg); }
     when 'W' { $wp.W(+$arg); }
     when 'L' { $wp.L(+$arg); }
     when 'R' { $wp.R(+$arg); }
     when 'F' { $x += $wp.x * $arg; $y += $wp.y * $arg; }
   }
}
say ($x.abs + $y.abs).round;
