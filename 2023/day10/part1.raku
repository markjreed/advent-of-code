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
my $up    = $i > 0             ?? @grid[$i-1][$j] !! '.';
my $right = $j < @grid[$i] - 1 ?? @grid[$i][$j+1] !! '.';
my $down  = $i < @grid - 1     ?? @grid[$i+1][$j] !! '.';
my $left  = $j > 0             ?? @grid[$i][$j-1] !! '.';

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
@distances[$i][$j] = 0;

my $done = False;
my @heads = [ [$i, $j], ];
while @heads {
  my @new = ();
  while @heads {
    my ($i, $j) = shift @heads;
    my $dist = @distances[$i][$j] + 1;
    my $from = @grid[$i][$j];
    if $i > 0 {
      my ($ni, $nj) = $i-1, $j;
      my $to = @grid[$ni][$nj];
      if connects-up($from, $to) {
        if @distances[$ni][$nj] == -1 || $dist < @distances[$ni][$nj] {
          @distances[$ni][$nj] = $dist;
          @new.push([$ni,$nj]);
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
        }
      }
    }
    if $j > 0 {
      my ($ni, $nj) = $i, $j-1;
      my $to = @grid[$ni][$nj];
      if connects-left($from, $to) {
        if @distances[$ni][$nj] == -1 || $dist < @distances[$ni][$nj] {
          @distances[$ni][$nj] = $dist;
          @new.push([$ni,$nj]);
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
