#!usr/bin/env raku
use MONKEY-SEE-NO-EVAL;
my @descriptions = $*ARGFILES.slurp.split("\n\n");

my %start = gather for @descriptions {
   my ($number, %monkey);
   for .lines {
     if /^'Monkey' \s+ (\d+)/ {
       $number = +$0;
     } elsif /'Starting items:' \s* (.*)/ {
       %monkey«items» = $0.split(/','\s*/).Array;
     } elsif /'Operation:' \s* (.*) / {
       %monkey«op» = $0.subst(/('new'|'old')/,{ "\$$0" },:g);
     } elsif /'Test: divisible by' \s+ (\d+)/ {
       %monkey«divisor» = +$0;
     } elsif /'If' \s+ ('true'|'false') ':' \s+ 'throw to monkey' \s+ (\d+)/ {
       %monkey«target»{$0} = +$1;
     }
   }
   take $number => %monkey;
};

my $lcm = [*]  %start.values.map:{$_«divisor»};

for ^2 -> $part {
  my %monkeys = %start.deepmap(->$c is copy {$c});
  my $rounds = [20, 10000][$part];
  my $width = $rounds.chars;
  for ^$rounds -> $round {
    printf "Round %{$width}d/%d\r", $round+1, $rounds;
    for %monkeys.sort».kv -> ($n, $monkey) {
      while $monkey«items» {
        $monkey«inspections»++;
        my $item = $monkey«items».shift;
        my $old = $item; my $new; EVAL $monkey«op»; $item = $new;
        $item div= 3 unless $part;
        $item %= $lcm;
        my $result = lc($item %% $monkey«divisor»);
        my $target = $monkey«target»{$result};
        %monkeys{$target}«items».push($item);
      }
    }
  }
  say "Part {$part+1}: {[*] %monkeys.values.map({ $_«inspections» }).sort[*-2,*-1]}";
}
