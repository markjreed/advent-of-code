#!/usr/bin/env raku
unit sub MAIN($input);

my (@seeds, %maps, $map);

for $input.IO.lines -> $line {
  if $line ~~ /^'seeds:'/ {
    @seeds = $line.words[1..*].map: -> $start, $length { |($start..^$start+$length) }
    say "Found {+@seeds} seeds";
    next;
  }
  if $line ~~ /^(\S+)\s+'map:'/ {
     $map = %maps{$0} = {};
     next;
  }
  next unless $line ~~ /\d/;
  my ($to, $start, $length) = $line.words;
  my $from = "$start,{$start + $length - 1}";
  $map{$from} = $to;
}

my $from-category = 'seed';
my @data = @seeds;
my $to-category;
while my $key = %maps.keys.grep: { $to-category = $0 if /^$from-category '-to-' (.*)/ } {
  $map = %maps{$key};
  @data .= map: -> $item is copy {
    my ($start, $stop, $target);
    for $map.kv -> $range, $mapping { 
      my ($begin, $end) = $range.split(','); 
      if $begin <= $item <= $end {
        ($start, $stop, $target) = $begin, $end, $mapping;
        last;
      }
    }
    $target ?? $item - $start + $target !! $item;
  };
  $from-category = $to-category;
}
say @data.min;
