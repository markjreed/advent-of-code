#!/usr/bin/env raku
my ($coords, $folds) =
  slurp.split("\n\n", :skip-empty)».split("\n", :skip-empty);

my $dots = ($coords.map: { Complex.new(|.split(',')».Int) }).SetHash;

my $first = True;
for @$folds {
  my ($dir,$axis) := m/(<[xy]>)'='(\d+)/;
  my ($m, $i) = do given $dir {
    when 'x' { { .re },  1; }
    when 'y' { { .im },  i; }
  };

  my @dots = $dots.keys;
  for @dots.grep: { .$m > $axis } -> $point {
    my $new = $point + 2*$i*($axis - $point.$m);
    $dots.unset($point);
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
