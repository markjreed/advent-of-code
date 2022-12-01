unit sub MAIN($input-file, :$generations=6);

class CellSpace {
  has %.space;
  has ($.min_x, $.min_y, $.min_z, $.min_w);
  has ($.max_x, $.max_y, $.max_z, $.max_w);
  has $.generation;

  method BUILD(:@lines) {
    %!space = ();
    ($!min_x, $!min_y, $!min_z, $!min_w,
     $!max_x, $!max_y, $!max_z, $!max_w,
     $!generation) X= 0;

    my ($z,$w) X= 0;

    for @lines.kv -> $y, $line {
      $!max_y = $y if $y > $!max_y;
      for $line.comb.kv -> $x, $char {
        $!max_x = $x if $x > $!max_x;
        %!space{"$x,$y,$z,$w"} = ($char eq '#');
        say "($x,$y,$z,$w) = {?%!space{"$x,$y,$z,$w"}}"
      }
    }
  }

  method gist {
    my $result = "Current state after $!generation cycles:\n";
    for $!min_w .. $!max_w -> $w {
      for $!min_z .. $!max_z -> $z {
        $result ~= "z=$z,w=$w\n";
        for $!min_y .. $!max_y -> $y {
          for $!min_x .. $!max_x -> $x {
            $result ~= (%!space{"$x,$y,$z,$w"} ?? '#' !! '.');
          }
          $result ~= "\n";
        }
        $result ~= "\n";
      }
    }
    return $result ~ "There are {$.live} active cubes.\n";
  }

  method succ {
    my %copy;
    for $!min_w - 1 .. $!max_w + 1 -> $w {
      for $!min_z - 1 .. $!max_z + 1 -> $z {
        for $!min_y -1 .. $!max_y + 1 -> $y {
          for $!min_x -1 .. $!max_x + 1 -> $x {
            my $cell = %!space{"$x,$y,$z,$w"};
            my $neighbors = 0;
            for -1 .. 1 -> $dx {
              my $nx = $x + $dx;
              for -1 .. 1 -> $dy {
                my $ny = $y + $dy;
                for -1 .. 1 -> $dz {
                  my $nz = $z + $dz;
                  for -1 .. 1 -> $dw {
                    next unless $dx || $dy || $dz || $dw; 
                    my $nw = $w + $dw;
                    if %!space{"$nx,$ny,$nz,$nw"} {
                      $neighbors++;
                    }
                  }
                }
              }
            }
            %copy{"$x,$y,$z,$w"} = $neighbors == 3 || ($cell && $neighbors == 2);
          }
        }
      }
    }
    %!space = %copy;
    $!min_w--; $!min_z--; $!min_y--; $!min_x--;
    $!max_w++; $!max_z++; $!max_y++; $!max_x++;
    $!generation++;
    return self;
  }

  method live {
    +(%!space.values.grep: { $_ })
  }
}

my $state = CellSpace.new(lines => $input-file.IO.lines);

for ^$generations {
   say $state;
   $state++;
}
say $state;
