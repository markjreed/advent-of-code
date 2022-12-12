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
    my $elevation = elevation($letter);
    for (-1,0),(0,1),(1,0),(0,-1) -> ($di, $dj) {
      my $ni = $i + $di;
      if 0 <= $ni < @map {
        my $nj = $j+$dj;
        if 0 <= $nj < @map[$ni] {
          my $nelevation = elevation(@map[$ni][$nj]);
          if $nelevation <= $elevation + 1 {
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
    my $new = $heads.clone;
    for $heads.keys -> $node {
      next unless $node ~~ Str;
      for @(%edges{$node}) -> $neighbor {
        next unless $neighbor ~~ Str;
        $new.set($neighbor);
      }
    }
    $heads = $new;
  }
  say "Part {$part+1}: $distance";
}
