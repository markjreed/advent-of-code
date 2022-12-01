#!/usr/bin/env perl
use v5.18;

my $verbose;
my $last_turn = 2020;

while ($ARGV[0] =~ /^-/) {
  for (shift @ARGV) {
    if (/^-v/)         { $verbose = 1; }
    elsif (/^-t(\d+)/) { $last_turn = $1; }
    elsif (/^-t$/)     { $last_turn = shift @ARGV; }
    else {
      die "Usage: $0 [-t last-turn] [-v] start-list\n";
    }
  }
}

my @starting_list = split ',', $ARGV[0];
my $last = pop @starting_list;
my @indices = 0..$#starting_list;

if ($verbose) {
   say "Turn ${\($_+1)}: $starting_list[$_]" for @indices;
}

my $turn = @indices;
my %spoken = map { $starting_list[$_] => $_ } @indices;

while ($turn < $last_turn - 1) {
  say "Turn ${\($turn+1)}: $last" if $verbose;
  my $say = 0;
  $say = $turn - $spoken{$last} if defined $spoken{$last};
  $spoken{$last} = $turn++;
  $last = $say;
}

print "Turn ${\($turn+1)}: " if $verbose;
say $last;
