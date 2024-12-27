#!/usr/bin/env raku
unit sub MAIN($input);

my @schematics = $input.IO.slurp.split("\n\n").map(*.split("\n")».comb.grep(+*));
my (@locks, @keys);

for @schematics -> $schematic; {
     my $height = +@$schematic;
     my @transposed = [Z](@$schematic);
     my @heights = @transposed.map(+*.grep({$_ eq '#'}) - 1);
     (@transposed[0][0] eq '#' ?? @locks !! @keys).push: [$height, |@heights];
}

say "locks: {@locks.raku}";
say "keys: {@keys.raku}";

my $part1 = 0;
for @locks X @keys -> ($lock, $key) {
    my $height = $lock[0];
    $part1++ unless (@($lock[1..*]) Z+ @($key[1..*])).grep: { $_+1 >= $height };
}
say $part1;
