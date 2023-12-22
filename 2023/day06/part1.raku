#!/usr/bin/env raku
unit sub MAIN($input, :$debug=False);
my ($times, $records) = $input.IO.lines».words»[1..*];

my $p = 1;
for (@$times Z @$records).kv -> $i, [$t, $r] {
    say "Race {$i+1}: $t ms, record $r mm." if $debug;
    my $ways-to-win = +(0..$t).map({ $_ * ($t-$_)}).grep: * > $r;
    say "Ways to win: $ways-to-win" if $debug;
    $p *= $ways-to-win;
}
print "Total: " if $debug;
say $p;
