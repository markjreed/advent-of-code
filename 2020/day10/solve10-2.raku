#!/usr/bin/env raku
sub MAIN($input-file, :$limit = 3);

my @adapters = $input-file.IO.lines.map(*.Int).sort;
@adapters.push(my $device = @adapters[*-1]+3); 

my %paths = 0 => 1;

for @adapters -> $adapter {
  %paths{$adapter} = [+]( (^3).map: { %paths{$adapter-1-$_} // 0 } );
}
say %paths{$device};
