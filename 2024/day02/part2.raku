#!/usr/bin/env raku
sub is-safe(@reports is copy) {
    @reports .= Array;
    my @reversed = @reports.reverse.Array;
    my @sorted = @reports.sort.Array;
    if !(@sorted eqv @reports) && !(@sorted eqv @reversed) {
        return False;
    }

    my $last;
    for @reports.kv -> $i, $report  {
        if $i > 0 {
            my $delta = abs($report - $last);
            unless 1 <= $delta <= 3 {
                return False;
            }
        }
        $last = $report;
    }
    return True;
}

sub is-safe-enough(@reports) {
    return True if is-safe(@reports) ;
    for (^+@reports).map(|{ @reports.rotate($_)[1..*].rotate(-$_) }) -> $report {
        return True if is-safe(@$report)
    }
    return False;
}

my $total = [+](gather for lines() -> $line {
    my @reports = $line.words.map(+*);
    take +is-safe-enough(@reports);
});
say $total;
