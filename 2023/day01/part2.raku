#!/usr/bin/env raku
unit sub MAIN($file);

my @digits = «zero one two three four five six seven eight nine»;
my %values =  (|@digits,|(0..9)) Z=> (|(0..9),|(0..9));
my @patterns = |@digits, |(0..9);
my @flipped = @patterns».flip;

my $total = 0;
for $file.IO.lines -> $line is copy {
  my $first = ~($line ~~ /@patterns/);
  my $last = ~($line.flip ~~ /@flipped/).flip;
  my $value = 10 * %values{$first} + %values{$last};
  say "$line: first=$first, last=$last, value=$value";
  $total += $value;
}
say $total;
