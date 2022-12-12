#!/usr/bin/env perl
use v5.36;
use experimental qw(signatures);

my @map = map { chomp; [split ''] } <>;

sub elevation($letter) {
  $letter =~ tr /SE/az/;
  return ord($letter) - ord('a');
}

my (@alternates, %edges, $start, $end);

foreach my $i (0..$#map) {
  my @row = @{$map[$i]};
  foreach my $j (0..$#row) {
    my $letter = $row[$j];
    my $coords = "$i,$j";
    if ($letter eq 'S') {
      $start = $coords;
    } elsif ($letter eq 'E') {
      $end = $coords;
    } elsif ($letter eq 'a') {
      push(@alternates, $coords);
    }
    my $level = elevation($letter);
    foreach my $delta ([-1,0],[0,1],[1,0],[0,-1]) {
      my ($di, $dj) = @$delta;
      my $ni = $i + $di;
      if (0 <= $ni && $ni < @map) {
        my $nj = $j + $dj;
        if (0 <= $nj && $nj < @{$map[$ni]}) {
          my $nlevel = elevation($map[$ni][$nj]);
          push @{$edges{$coords}},"$ni,$nj" if $nlevel <= $level + 1;
        }
      }
    }
  }
}

foreach my $part (0..1) {
  my %heads = ($start => 1);
  if ($part) {
    @heads{@alternates} = (1) x @alternates;
  }

  my $distance = 0;
  while (!$heads{$end}) {
    $distance++;
    my %copy = %heads;
    foreach my $node (keys %copy) {
      foreach my $neighbor (@{$edges{$node}}) {
        $heads{$neighbor} = 1;
      }
    }
  }

  say "Part ${\($part+1)}: $distance";
}
