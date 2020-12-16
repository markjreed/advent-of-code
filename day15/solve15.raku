#!/usr/bin/env raku
unit sub MAIN($starting-numbers, :$verbose=False, :$position=2020);

my @starting-list = $starting-numbers.split(',');
my $last = @starting-list.pop;

if ($verbose) {
   print "Turn {.key+1}: {.value}\n" for @starting-list.pairs;
}

my $turn = +@starting-list;
my %spoken = @starting-list.antipairs;

while ($turn < $position-1) {
   say "Turn {$turn+1}: $last" if $verbose;
   my $next = %spoken{$last}:exists ?? $turn - %spoken{$last} !! 0;
   %spoken{$last} = $turn++;
   $last = $next;
}

print "Turn {$turn+1}: " if $verbose;
say $last;
