#!/usr/bin/env raku
unit sub MAIN($starting-numbers, :$verbose=False, :$position=2020);

my @start = $starting-numbers.split(',');
my $last = @start.pop;
my %spoken = @start.antipairs;

my $turn = +@start;
while ($turn < $position-1) {
   my $next = %spoken{$last}:exists ?? $turn - %spoken{$last} !! 0;
   %spoken{$last} = $turn;
   $last = $next;
   $turn++;
}
print "Turn {$turn+1}: " if $verbose;
say $last;
