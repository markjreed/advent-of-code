#!/usr/bin/env raku
my @map = $*ARGFILES.lines».&{.comb.Array};

sub elevation($letter) {
  $letter.trans('S'=>'a', 'E'=>'z').ord - 'a'.ord;
}

my ($start, @alternates, $end, %edges);
for @map.kv -> $i, @row {
  for @row.kv -> $j, $letter {
    my $coords = ~($i + i*$j);
    if $letter eq 'S' {
      $start = $coords;
    } elsif $letter eq 'E' {
      $end = $coords;
    } elsif $letter eq 'a' {
      @alternates.push: $coords
    }
    my $level = elevation($letter);
    for (-1,0),(0,1),(1,0),(0,-1) -> ($di, $dj) {
      my $ni = $i + $di;
      if 0 <= $ni < @map {
        my $nj = $j+$dj;
        if 0 <= $nj < @map[$ni] {
          my $nlevel = elevation(@map[$ni][$nj]);
          if $nlevel <= $level + 1 {
             %edges{$coords}.push: ~($ni + i*$nj);
          }
        }
      }
    }
  }
}

for ^2 -> $part {
  my @start = $part ?? [$start,|@alternates] !! [$start];
  my $heads = SetHash.new(@start);
  my $distance = 0;
  while $end ∉ $heads {
    $distance++;
    for [$heads.keys] -> $node {
      for @(%edges{$node}//[]) -> $neighbor {
        $heads.set($neighbor);
      }
    }
  }
  say "Part {$part+1}: $distance";
}
