#!/usr/bin/env raku
my @rocks = $*ARGFILES.lines».split(' -> ')».split(',')».Int;

my @points = (
  gather for @rocks -> @rock { for @rock -> $point { take $point } }
);
push @points, my $entry = (500,0);

my ($min-x, $max-x) = @points».[0].&{.min-1, .max+1};
my ($min-y, $max-y) = @points».[1].&{.min, .max};

my $width = $max-x - $min-x + 1;
my $height = $max-y - $min-y + 1;

my %pic;

sub draw($x, $y, $char='#') {
  %pic{"$x,$y"} = $char;
}

sub query($x, $y) {
  return %pic{"$x,$y"} if %pic{"$x,$y"}:exists;
  return '#' if $y == $max-y + 2;
  return '.';
}

for ^2 -> $part {

  %pic = ();
  for @rocks -> @rock is copy {
   my ($x1,$y1) = @rock.shift;
   draw $x1, $y1;
   while @rock {
     my ($x2,$y2) = @rock.shift;
     if $x1 == $x2 {
       draw $x1,$_ for $y1...$y2;
     } elsif $y1 == $y2 {
       draw $_,$y1 for $x1...$x2;
     } else {
       die "Diagonal rock!"
     }
     ($x1, $y1) = $x2, $y2;
    }
  }

  draw |($entry),'+';

  # simulate the sand
  my $done = False;
  my $units = 0;
  while not $done {
    my ($sx, $sy) = $entry;
    my $stopped = False;
    repeat {
      my $ny = $sy + 1;
      if $ny > $max-y && !$part {
        $done = True;
        last;
      }
      my @nx = [$sx, $sx-1, $sx+1].grep: { query($_, $ny) eq '.' };
      if +@nx {
        ($sx, $sy) = (@nx[0], $ny);
      } else {
        $stopped = True;
        $done =  ($sx, $sy) eqv $entry if $part;
        $units++;
      }
      my $was = query $sx, $sy;
      draw $sx, $sy, 'o';
      #render;
      draw $sx, $sy, $was;
    } until $stopped;
    draw $sx, $sy, 'o' unless $done;
  }

  say "Part {$part+1}: $units";
}
