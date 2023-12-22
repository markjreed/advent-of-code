#!/usr/bin/env raku
unit sub MAIN($input, :$debug=False);
my ($time, $record) = $input.IO.lines».words»[1..*]».join;

my $d = sqrt($time * $time - 4 * $record);
my $min-winner = ($time - $d)/2;
my $max-winner = ($time + $d)/2;
$min-winner++ if $min-winner.Int == $min-winner;
$min-winner .= ceiling;
$max-winner-- if $max-winner.Int == $max-winner;
$max-winner .= floor;
say "min winner is $min-winner" if $debug;
say "max winner is $max-winner" if $debug;
my $ways-to-win = $max-winner - $min-winner + 1;
print "Ways to win: " if $debug;
say $ways-to-win;
