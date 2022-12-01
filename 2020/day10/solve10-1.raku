#!/usr/bin/env raku
sub MAIN($input-file, :$limit = 3);

my @adapters = $input-file.IO.lines.map(*.Int);
my @chain = [0];
while (@adapters) {
  my $current = @chain[*-1];
  my $next = @adapters.grep( { $_ > $current && $_ - $current <= $limit } ).min;
  last if $next == Inf;
  @chain.push($next);
  @adapters = @adapters.grep: { $_ != $next };
}
@chain.push(@chain.max + 3);
say "Adapters chain: {@chain.join(',')}";
my @differences = [^(@chain-1)].map: { @chain[$^i+1] - @chain[$^i] };
my $product = 1;
for [1,3] -> $jolts {
  my $count = +@differences.grep($jolts);
  say "{$jolts}-jolt differences: $count";
  $product *= $count;
}
say "Product is $product.";

