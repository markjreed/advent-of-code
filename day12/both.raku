#!/usr/bin/env raku
my @paths = lines.map: { [=>] .split('-') };
my %caves;
for @paths -> $path {
  my ($from, $to) = $path.&{.key, .value};
  (%caves{$from} //= ().SetHash).set: $to;
  (%caves{$to} //= ().SetHash).set: $from;
}

sub count-paths($cave, $revisit-ok is copy=False, $small-visited = ().SetHash) {
  return 1 if $cave eq 'end';
  if $small-visited{$cave} {
    if $revisit-ok && $cave ne 'start' {
      $revisit-ok = False;
    } else {
      return 0;
    }
  }
  my $new-visited = $small-visited.clone;
  $new-visited.set($cave) if $cave ~~ /^<[a..z]>+$/;
  return [+] (count-paths($_, $revisit-ok, $new-visited) for %caves{$cave}.keys);
}
say count-paths('start');
say count-paths('start', True);
