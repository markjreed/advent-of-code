#!/usr/bin/env raku
unit sub MAIN($starting-numbers, :$verbose=False, :$turn=2020);

my @starting-list = $starting-numbers.split(',');
my $last = @starting-list.pop;

if ($verbose) {
   print "Turn {.key+1}: {.value}\n" for @starting-list.pairs;
}

my $current = +@starting-list;
my %spoken = @starting-list.antipairs;

while ($current < $turn-1) {
   say "Turn {$current+1}: $last" if $verbose;
   my $next = %spoken{$last}:exists ?? $current - %spoken{$last} !! 0;
   %spoken{$last} = $current++;
   $last = $next;
}

print "Turn {$current+1}: " if $verbose;
say $last;
