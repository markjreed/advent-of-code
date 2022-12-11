#!usr/bin/env raku
use MONKEY-SEE-NO-EVAL;
my @descriptions = $*ARGFILES.slurp.split("\n\n");

my @monkeys = @descriptions.map: {
   my %monkey;
   for .lines {
     if /'Starting items:' \s* (.*)/ {
       %monkey«items» = $0.split(/','\s*/);
     } elsif /'Operation:' \s* (.*) /
       %monkey«op» = $0.subst(/new|old/,"\$$&",:g);
     } elsif /'Test: divisible by' \s+ (\d+)/ {
       %monkey«test» = { $_ %% $0 };
     } elsif /'If' \s+ ('true'|'false') \s+ 'throw to monkey' \s+ (\d+)/ {
       %monkey«target»{$0} = $1;
     }
   }
   %monkey;
};
say @monkeys.raku;
