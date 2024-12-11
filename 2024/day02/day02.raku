#!/usr/bin/env raku
unit sub MAIN($input-file, :$debug = False);

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

my ($part1, $part2) »=» 0;
for $input-file.IO.lines().kv -> $i, $line {
    my @reports = $line.words.map(+*);
    if is-safe(@reports) {
        say "Line {$i+1} ($line) is safe." if $debug;
        $part1++;
        $part2++;
    } elsif is-safe-enough(@reports) {
        say "Line {$i+1} ($line) is safe." if $debug;
        $part2++;
    } elsif $debug {
        say "Line {$i+1} ($line) is unsafe.";
    }
}
say $part1;
say $part2;
