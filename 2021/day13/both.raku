#!/usr/bin/env raku
my ($coords, $folds) =
  slurp.split("\n\n", :skip-empty)».split("\n", :skip-empty);

my $dots = ($coords.map: { Complex.new(|.split(',')».Int) }).SetHash;

my $first = True;
for @$folds {
  my ($dir, $axis) := m/(<[xy]>)'='(\d+)/;
  my ($part, $vec) = do given $dir {
    when 'x' { { .re },  1; }
    when 'y' { { .im },  i; }
  };

  my @dots = $dots.keys;
  for @dots.grep: { .$part > $axis } -> $point {
    my $new = $point + 2*$vec*($axis - $point.$part);
    $dots.unset($point);
    $dots.set($new);
  }
  if $first {
    say +$dots;
    $first = False;
  }
}

my ($width, $height) = ({.re},{.im}).map: { $dots.keys».$_.max+1 };
my @grid = [ [ ' ' xx $width ] xx $height ];
for $dots.keys».reals -> ($x,$y) {
   @grid[$y][$x] = '#';
}
.join('').say for @grid;
