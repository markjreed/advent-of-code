#!/usr/bin/env raku
unit sub MAIN($input);

my $total = 0;
for $input.IO.lines.kv -> $nr, $_ {
  my ($pattern, $groups) = .words;
  my @unknowns =
    $pattern.comb.&{.cache.keys.grep: -> $i { .[$i] eq '?' }};
  next unless my $u = +@unknowns;
  my $max = 1 +< $u;
  my $count = 0;
  for ^$max -> $n {
    my @chars = $pattern.comb;
    for sprintf("\%0{$u}b", $n).comb.kv -> $i, $bit {
      my $ch = +$bit ?? '#' !! '.';
      @chars[@unknowns[$i]] = $ch;
    }
    my $result = count-groups(@chars.join).join(',');
    $count++ if $result eq $groups;
  }
  $total += $count;
  #printf "%4d: %d\r", $nr, $total;
}
say $total;

sub count-groups($line) {
  my $patched = ".$line.";
  my $group = 0;
  my @groups = ();
  for $patched.comb -> $c {
    if $c eq '.' {
      @groups.push($group) if $group;
      $group = 0;
    } elsif $c eq '#' {
      $group++;
    }
  }
  return @groups;
}
