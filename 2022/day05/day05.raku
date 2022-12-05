#!/usr/bin/env raku
my @data = $*ARGFILES.lines;

my $labels = @data.first({/\d/},:k);
my @pic = @data.head($labels);

# parse the picture into the starting configuration
my $x = 'xxx';
my $s3 = ' ' x 3;
my $s4 = " $s3";
my @s = [Z](@pic».&{S/^$s3/$x/}».&{S:g/$s4/ $x/}».words)».grep(* ne $x)».Array;

for ^2 -> $part {
  my %stacks = @data[$labels].words Z=> @s».clone;
  for @data.tail(*-($labels+2)) {
    die "Illegal move '$_'" 
      unless /move \s+ (\d+) \s+ from \s+ (\d+) \s+ to \s+ (\d+)/;
    if $part {
      %stacks{$2}.unshift: |%stacks{$1}.splice(0, +$0);
    } else {
      %stacks{$2}.unshift: %stacks{$1}.shift for ^$0;
    }
  }
  say "Part {$part+1}:{%stacks.sort».value»[0]».trans(«[ ]» X=> '').join}";
}
