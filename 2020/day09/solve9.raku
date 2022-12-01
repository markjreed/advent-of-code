unit sub MAIN($input-file, :$preamble=25);

my @lines = $input-file.IO.lines;
my @buffer;
my $error;
for @lines.kv -> $i, $line {
  if $i > $preamble {
    unless @buffer.combinations(2).grep: { $line == [+] $_ }  {
      $error = $line;
      last;
    }
    @buffer.shift;
  }
  @buffer.push($line);
}

die "No error found." unless $error;

say "Error is $error.";

my ($start, $end);
LOOP:
for ^@lines -> $i {
  my $sum = @lines[$i];
  for ($i+1)..^@lines -> $j {
    $sum += @lines[$j];
    if $sum == $error {
      $start = $i;
      $end = $j;
      last LOOP;
    }
  }
}

die "No weakness found" unless $end;

my @range = @lines[$start..$end];
say "Range found from $start to $end adding to $error; weakness is {@range.&{.min + .max}}";
