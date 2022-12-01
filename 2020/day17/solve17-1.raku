unit sub MAIN($input-file, :$generations=6);

class CellSpace {
  has %.space;
  has ($.min_x, $.min_y, $.min_z);
  has ($.max_x, $.max_y, $.max_z);
  has $.generation;

  method BUILD(:@lines) {
    %!space = ();
    ($!min_x, $!min_y, $!min_z, 
     $!max_x, $!max_y, $!max_z,
     $!generation, my $z) X= 0;

    for @lines.kv -> $y, $line {
      $!max_y = $y if $y > $!max_y;
      for $line.comb.kv -> $x, $char {
        $!max_x = $x if $x > $!max_x;
        %!space{"$x,$y,$z"} = ($char eq '#');
      }
    }
  }

  method gist {
    my $result = "Current state after $!generation cycles:\n";
    for $!min_z .. $!max_z -> $z {
      $result ~= "z=$z\n";
      for $!min_y .. $!max_y -> $y {
        for $!min_x .. $!max_x -> $x {
          my $char = (%!space{"$x,$y,$z"} ?? '#' !! '.');
          $result ~= (%!space{"$x,$y,$z"} ?? '#' !! '.');
        }
        $result ~= "\n";
      }
      $result ~= "\n";
    }
    return $result ~ "There are {$.live} active cubes.\n";
  }

  method succ {
    my %copy;
    for $!min_z - 1 .. $!max_z + 1 -> $z {
      for $!min_y -1 .. $!max_y + 1 -> $y {
        for $!min_x -1 .. $!max_x + 1 -> $x {
          my $cell = %!space{"$x,$y,$z"};
          my $neighbors = 0;
          for -1 .. 1 -> $dx {
            my $nx = $x + $dx;
            for -1 .. 1 -> $dy {
              my $ny = $y + $dy;
              for -1 .. 1 -> $dz {
                next unless $dx || $dy || $dz;
                my $nz = $z + $dz;
                if %!space{"$nx,$ny,$nz"} {
                  $neighbors++;
                }
              }
            }
          }
          %copy{"$x,$y,$z"} = $neighbors == 3 || ($cell && $neighbors == 2);
        }
      }
    }
    %!space = %copy;
    $!min_z--; $!min_y--; $!min_x--;
    $!max_z++; $!max_y++; $!max_x++;
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
