#!/usr/bin/env raku
my ($points,$folds) = slurp.split("\n\n", :skip-empty)».split("\n", :skip-empty);

my $dots = $points.map( { [ .split(',')».Int.&{ $_[0] + i*$_[1] } ] } ).SetHash;
my $first = True;
for @$folds {
  my ($dir,$axis) := m/(<[xy]>)'='(\d+)/;
  my @points = $dots.keys;
  for @points -> $pt  {
    my $new;
    given $dir {
       when 'x' {
         $new = 2*$axis - $pt.re + i*$pt.im if $pt.re > $axis;
       }
       when 'y' {
         $new = $pt.re + i*(2*$axis - $pt.im) if $pt.im > $axis;
       };
    }
    if ($new.defined) {
      $dots.unset($pt);
      $dots.set($new);
    }
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
