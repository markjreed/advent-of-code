#!/usr/bin/env raku
unit sub MAIN($input);

my @grid = [ $input.IO.lines».comb».Array ];

my @start;
OUTER-LOOP:
for @grid.kv -> $i, @row {
    for @row.kv -> $j, $cell {
        if $cell eq 'S' {
          @start = ($i, $j);
          last OUTER-LOOP;
        }
    }
}


sub connects-up   ($from, $to) { $from ~~ /<[|LJ]>/ && $to ~~ /<[|F7]>/; }
sub connects-right($from, $to) { $from ~~ /<[-FL]>/ && $to ~~ /<[-7J]>/; }
sub connects-down ($from, $to) { connects-up($to, $from); }
sub connects-left ($from, $to) { connects-right($to, $from); }

my ($i, $j) = @start;
my $surround = '';
print "Start is at ($i,$j)";
my $up    = $i > 0             ?? @grid[$i - 1][$j] !! '.';
my $right = $j < @grid[$i] - 1 ?? @grid[$i][$j+1] !! '.';
my $down  = $i < @grid - 1     ?? @grid[$i+1][$j] !! '.';
my $left  = $j > 0             ?? @grid[$i][$j - 1] !! '.';

my $covered;
if $up ~~ /<[|F7]>/ && $down ~~ /<[|LJ]>/ {
  $covered = '|';
} elsif $left ~~ /<[-LF]>/ && $right ~~ /<[-7J]>/ {
  $covered = '-';
} elsif $down ~~ /<[|LJ]>/ && $right ~~ /<[-7J]>/ {
  $covered = 'F';
} elsif $left ~~ /<[-LF]>/ && $down ~~ /<[|LJ]>/ {
  $covered = '7';
} elsif $up ~~ /<[|F7]>/ && $left ~~ <[-LF]> {
  $covered = 'J';
} elsif $right ~~ /<[-7J]>/ && $up ~~ /<[|F7]>/ {
  $covered = 'L';
}

say ", covering a $covered";
@grid[$i][$j] = $covered;

my @distances = @grid.map: { [ -1 xx @$_ ] };
my @found-by = @grid.map: { [ -1 xx @$_ ] };
my @sequence = @grid.map: { [ -1 xx @$_ ] };
my $vertex = $i + i * $j;
my @points = [ [$vertex.re, $vertex.im], ];;
@distances[$i][$j] = @found-by[$i][$j] = 0;

my $done = False;
my @heads = [ [$i, $j], ];
while @heads {
  my @new = ();
  my $head = -1;
  while @heads {
    my ($i, $j) = shift @heads;
    $head++;
    my $dist = @distances[$i][$j] + 1;
    my $from = @grid[$i][$j];
    if $i > 0 {
      my ($ni, $nj) = $i - 1, $j;
      my $to = @grid[$ni][$nj];
      if connects-up($from, $to) {
        if @distances[$ni][$nj] == -1 || $dist < @distances[$ni][$nj] {
          @distances[$ni][$nj] = $dist;
          @new.push([$ni,$nj]);
          @points.push([$ni,$nj]);
          @found-by[$ni][$nj] = $head++;
        }
      }
    }
    if $j < @grid[$i] - 1 {
      my ($ni, $nj) = $i, $j+1;
      my $to = @grid[$ni][$nj];
      if connects-right($from, $to) {
        if @distances[$ni][$nj] == -1 || $dist < @distances[$ni][$nj] {
          @distances[$ni][$nj] = $dist;
          @new.push([$ni,$nj]);
          @points.push([$ni,$nj]);
          @found-by[$ni][$nj] = $head++;
        }
      }
    }
    if $i < @grid - 1 {
      my ($ni, $nj) = $i+1, $j;
      my $to = @grid[$ni][$nj];
      if connects-down($from, $to) {
        if @distances[$ni][$nj] == -1 || $dist < @distances[$ni][$nj] {
          @distances[$ni][$nj] = $dist;
          @new.push([$ni,$nj]);
          @points.push([$ni,$nj]);
          @found-by[$ni][$nj] = $head++;
        }
      }
    }
    if $j > 0 {
      my ($ni, $nj) = $i, $j - 1;
      my $to = @grid[$ni][$nj];
      if connects-left($from, $to) {
        if @distances[$ni][$nj] == -1 || $dist < @distances[$ni][$nj] {
          @distances[$ni][$nj] = $dist;
          @new.push([$ni,$nj]);
          @points.push([$ni,$nj]);
          @found-by[$ni][$nj] = $head++;
        }
      }
    }
  }
  @heads = @new;
}

my $max;
for @distances.kv -> $i, @row {
  for @row.kv -> $j, $distance {
     if (!defined $max) || ($distance > $max) {
        $max = $distance but { :i($i), :j($j) };
     }
  }
}
say "Furthest point in pipe is ({$max.Hash«i»}, {$max.Hash«j»}) at distance $max from start.";

for @found-by.kv -> $i, @row {
  for @row.kv -> $j, $head {
    if (my $position = @distances[$i][$j]) >= 0 {
      $position = 2*$max - $position if $head;
      @sequence[$i][$j] = $position;
    }
  }
}

for @sequence.kv -> $i, @row {
   for @row.kv -> $j, $seq {
      if $seq < 0 {
         printf '%4s', '.';
      } else {
         printf '%4d', $seq;
      }
   }
   say '';
}

@points .= sort: -> ($i,$j) { @sequence[$i][$j] };

my $sum = 0;
for ^@points -> $i {
    my ($x1, $y1) = @points[$i];
    my ($x2, $y2) = @points[($i + 1) % @points];
    $sum += $x1 * $y2 - $x2 * $y1;
}
my $area = $sum/2;
say "Area enclosed: $area";
say "Boundary points: {+@points}";
say "Interior points: {floor($area - @points/2 + 1)}";
