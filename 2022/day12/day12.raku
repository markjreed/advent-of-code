#!/usr/bin/env raku
use JSON::Fast;
my @map = $*ARGFILES.lines».&{.comb.Array};

sub elevation($letter) {
  $letter.trans('S'=>'a', 'E'=>'z').ord - 'a'.ord;
}

my ($start, @alternates, $end, %edges, @vertices);
for @map.kv -> $i, @row {
  for @row.kv -> $j, $letter {
    my $coords = $i + i*$j;
    if $letter eq 'S' {
      $start = ~$coords;
    } elsif $letter eq 'E' {
      $end = ~$coords;
    } elsif $letter eq 'a' {
      @alternates.push: ~$coords
    }
    my $elevation = elevation($letter);
    @vertices.push(~$coords);
    for (-1,0),(0,1),(1,0),(0,-1) -> ($di, $dj) {
      my $ni = $i + $di;
      if 0 <= $ni < @map {
        my $nj = $j+$dj;
        if 0 <= $nj < @map[$ni] {
          my $nelevation = elevation(@map[$ni][$nj]);
          if $nelevation <= $elevation.succ {
             %edges{$coords}.push: ~($ni + i*$nj);
          }
        }
      }
    }
  }
}

sub dijkstra($start, $end) {
  my $unvisited = SetHash.new(@vertices);
  my %distance = @vertices »=>» ∞;
  %distance{$start} = 0;
  my $curr = $start;
  while $end ∊ $unvisited {
    my $distance = %distance{$curr};
    for @(%edges{$curr}) -> $neighbor {
      next unless $neighbor;
      my $old = %distance{$neighbor};
      my $new = min($old, $distance + 1);
      %distance{$neighbor} = $new;
    }
    $unvisited.unset($curr);
    if $unvisited {
      $curr = $unvisited.keys.min: { %distance{$_} };
    }
  }
  return %distance{$end};
}
my $min = dijkstra($start, $end);
say "Part 1: $min";
my $count = +@alternates;
say "There are {$count+1} possible starting locations for part 2.";
for @alternates.kv -> $i, $alt {
  printf "\%0{$count.chars}d/%d\r", $i+2, $count+1;
  my $dist = dijkstra($alt, $end);
  $min = min($min, $dist);
}
print "\n";
say "Part 2: $min";
