#!/usr/bin/env raku
use JSON::Fast;
my @map = $*ARGFILES.lines».&{.comb.Array};

my $height = +@map;
my @width = @map.map({+@$_}).unique;
die "Inconsistent width: {@width}" if +@width != 1;
my $width = @width[0];

my @visible = @map».map({ 0 })».Array;

my %from;
%from«left» = @map;
%from«right» = @map».reverse».Array;
%from«top» = ([Z] @map)».Array;
%from«bottom» = %from«top»».reverse».Array;

my %coords = left => {($^i, $^j+$^l-$^l)}, right => {($^i, $^l-1-$^j)},
             top =>  {($^j, $^i+$^l-$^l)}, bottom => {($^l-1-$^j, $^i)};

for %from.kv -> $dir, @major {
  my $trans = %coords{$dir};
  for @major.kv -> $i, @minor {
    my $height = -1;
    for @minor.kv -> $j,  $tree {
      if $tree > $height {
        my ($y, $x) = $trans.($i,$j,+@minor);
        @visible[$y][$x] = 1;
        $height = $tree;
      }
    }
  }
}
my $part1 = [+] @visible».sum;

my $part2 = max gather for ^$height -> $i {
  for ^$width -> $j {
    my $this = @map[$i][$j];
    my $score = [*] gather for ((-1,0),(0,1),(1,0),(0,-1)) -> ($di,$dj) {
      my $visible = 0;
      my ($ni, $nj) = $i+$di, $j+$dj;
      while $ni >= 0 && $ni < $height && $nj >= 0 && $nj < $width {
        $visible++;
        last if @map[$ni][$nj] >= $this;
        ($ni, $nj) = $ni+$di, $nj+$dj;
      }
      take $visible;
    }
    take $score;
  }
}

say "Part 1: $part1";
say "Part 2: $part2";

