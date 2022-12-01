unit sub MAIN($input-file, :$start-heading=90);

use lib '.';
use Solve12;

my $h = Heading.new(degrees => $start-heading);
my ($x, $y) = (0,0);
for $input-file.IO.lines -> $line {
   my ($op, $arg) = @( $line ~~ / (<[NSEWLRF]>) (\d+) / ).map(~*);
   given $op {
     when 'N' { $y += +$arg; }
     when 'S' { $y -= +$arg; }
     when 'E' { $x += +$arg; }
     when 'W' { $x -= +$arg; }
     when 'L' { $h += -$arg; }
     when 'R' { $h += +$arg; }
     when 'F' { $x += +$arg * cos($h.radians); $y += +$arg * sin($h.radians); }
   }
}
say ($x.abs + $y.abs).round;
