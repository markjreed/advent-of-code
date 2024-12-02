#!/usr/bin/env raku
sub is-safe(@reports) {
    
    my @reversed = @reports.reverse;
    my @sorted = @reports.sort;
    print "{@reports}: ";
    if !(@sorted eqv @reports) && !(@sorted eqv @reversed) {
        say "UNSAFE - not sorted";
        return False;
    }

    my $last;
    for @reports.kv -> $i, $report  {
        if $i > 0 {
            my $delta = abs($report - $last);
            unless 1 <= $delta <= 3 {
                say "UNSAFE - $last to $report is a delta of $delta";
                return False;
            }
        }
        $last = $report;
    }
    say "SAFE";
    return True;
}

my $total = [+](gather for lines() -> $line {
    my @reports = $line.words.map(+*);
    take is-safe(@reports) ?? 1 !! 0;
});
say $total;
