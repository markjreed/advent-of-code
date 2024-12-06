#!/usr/bin/env raku
my %prereqs;
my ($part1, $part2) »=» 0;

my @lines = lines; 
while @lines {
    given @lines.shift {
        if m/ ( \d+ ) '|' (\d+ ) / {
            %prereqs{$1}{$0} = True;
        } elsif / ',' / {
            @lines.unshift($_);
            last;
        }
    }
}

sub comparePages($page1, $page2) {
    if %prereqs{$page2}{$page1} {
        return -1;
    } elsif %prereqs{$page1}{$page2} {
        return 1;
    } else {
        return 0;
    }
}

for @lines {
    my %seen;
    my @pages = .split(',');
    my @sorted = sort(&comparePages, @pages);
    if @pages eqv @sorted {
        $part1 += @pages[@pages div 2];
    } else {
        $part2 += @sorted[@sorted div 2];
    }
}

.say for $part1, $part2;
