#!/usr/bin/env raku
unit sub MAIN($input-file);

class Cells {

  has @.cells;
  has $.generation;

  submethod BUILD(:@!cells, :$!generation=0) { }

  method gist {
    [@!cells.map( *.join(' ') )].join: "\n";
  }

  method succ {
    my @copy;
    for ^+@!cells -> $i {
      @copy[$i] = [];
      my @row := @!cells[$i].cache;
      for ^@row -> $j {
        my $state = @row[$j];
        my $occupied = 0;
        for (-1,0,1) -> $di {
          my $ni = $i + $di;
          next if $ni < 0 || $ni >= @!cells;
          for (-1,0,1) -> $dj {
            next unless $di || $dj;
            my $nj = $j + $dj;
            next if $nj < 0 || $nj >= @row;
            $occupied++ if @!cells[$ni][$nj] eq '#';
          }
        }
        @copy[$i][$j] = (given ($state, $occupied) {
          when ('L', 0)  { '#' }
          when ('#', * >= 4) { 'L' }
          default { $state }
        });
      }
    }
    Cells.new(cells => @copy, generation => $.generation+1)
  }

  method occupied {
    +flat(@!cells.map( -> @row { @row.grep: { $_ eq '#' } } ));
  }
}

my $field = Cells.new(cells => $input-file.IO.lines.map: *.comb);

my $next = $field++;
while ($next.gist ne $field.gist) {
    $next = $field++;
}

say "Stabilized after { $field.generation - 1 } iterations with {$field.occupied} occupied seats:\n{ $field.gist }";
