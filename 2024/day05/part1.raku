#!/usr/bin/env raku
my %prereqs;
my $total = 0;

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
for @lines {
    my %seen;
    my @pages = .split(',');
    my $ok = True;
    UPDATE: for @pages -> $page {
        if my $p = %prereqs{$page} {
            for $p.keys -> $prereq {
                if $prereq (elem) @pages && !%seen{$prereq}  {
                    $ok = False;
                    last UPDATE;
                }
            }
        }
        %seen{$page} = True;
   }
   if $ok {
       $total += @pages[@pages div 2];
   }
}

say $total;
