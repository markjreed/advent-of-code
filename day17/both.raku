#!/usr/bin/env raku
my ($x0,$x1,$y0,$y1) = @(lines[0] ~~
  /'x=' (\d+) '..' (\d+) ',' \s*
   'y=' ('-'? \d+) '..' ('-'? \d+)/);

die "Unable to parse input" unless $y1;

# make sure they're in the right order
($x0, $x1) = $x1, $x0 if $x1 < $x0;
($y0, $y1) = $y1, $y0 if $y1 < $y0;

# smallest horizontal velocity that can possibly get us to the target
# (Largest is x1, which gets us there in one step.)
my $min-vx = floor((sqrt(8*$x0+1)-1)/2);

# largest vertical velocity that won't overshoot
my $max-vy = -1-$y0;

# maximum height we can reach (while still hitting the target)
my $max-height = -Inf;

my @solutions = gather for ($min-vx .. $x1) X ($y0 .. $max-vy) -> ($vx,$vy) {
  my ($dx,$dy,$x,$y) = $vx,$vy,0,0,0;
  my $max-trial = -Inf;
  while $y >= $y0 {
    $x += $dx;
    $y += $dy;
    $max-trial = $y if $y > $max-trial;
    $dx -= sign($dx);
    $dy--;
    if ([<=] $x0, $x, $x1) && ([<=] $y0, $y, $y1) {
      take ($vx, $vy);
      $max-height = $max-trial if $max-trial > $max-height;
      last;
    }
  }
}

say "Maximum height: $max-height";

say "There are {+@solutions} solutions.";
