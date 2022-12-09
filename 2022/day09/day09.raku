#!/usr/bin/env raku
my %delta = U => [-1,0], R => [0,1], D => [1,0], L => [0,-1];
my @moves = $*ARGFILES.lines».words».Array;
for ^2 -> $part {
   my @knots = [ [0,0] xx 2 + 8 * $part ];
   my $tail := @knots[*-1];
   my %visited;
   %visited{"$tail[0],$tail[1]"} = 1;
   for @moves -> ($dir, $count) {
     for ^$count {
       # move head
       @(@knots[0]) Z+= @(%delta{$dir});

       # move the rest of the knots to follow
       for 1..^@knots -> $n {
         my $di = @knots[$n-1][0]-@knots[$n][0];
         my $dj = @knots[$n-1][1]-@knots[$n][1];
         my $td = [+] ($di, $dj)».abs;
         if $td > 2 or ($td == 2 && ($di==0 or $dj==0)) {
           @knots[$n][0] += sign($di);
           @knots[$n][1] += sign($dj);
         }
       }
       # track the tail
       %visited{"$tail[0],$tail[1]"} = 1;
    }
  }
  say "Part {$part+1}: Tail visited a total of {+%visited} spaces.";
}
