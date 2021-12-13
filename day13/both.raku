#!/usr/bin/env raku
my ($points,$folds) =
  slurp.split("\n\n", :skip-empty)».split("\n", :skip-empty);

my $dots = $points.map(
  { [ .split(',')».Int.&{ $_[0] + i*$_[1] } ] }
).SetHash;

my $first = True;
for @$folds {
  my ($dir,$axis) := m/(<[xy]>)'='(\d+)/;
  my ($m, $i) = do given $dir {
    when 'x' { { .re },  1; }
    when 'y' { { .im },  i; }
  };

  my @points = $dots.keys;
  for @points.grep: { .$m > $axis } -> $pt {
    my $new = $pt + 2*$i*($axis - $pt.$m);
    $dots.unset($pt);
    $dots.set($new);
  }
  if $first {
    say +$dots;
    $first = False;
  }
}

my $width = $dots.keys».re.max+1;
my $height = $dots.keys».im.max+1;
my @grid = [ [ ' ' xx $width ] xx $height ];
for $dots.keys».&{.re,.im} -> ($x,$y) {
   @grid[$y][$x] = '#';
}
.join('').say for @grid;
