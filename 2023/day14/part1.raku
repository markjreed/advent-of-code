#!/usr/bin/env raku
unit sub MAIN($input);

my @platform = $input.IO.lines».comb».Array.Array;

say "\nBefore tilting:";
.join.say for @platform;

my $end = @platform.end;

for ($end ... 0) -> $i {
    my @row := @platform[$i];

    for @row.kv -> $j, $sym {
        if $sym eq 'O' && $i {
            my $next = $i - 1;
            $next-- while $next && @platform[$next][$j] eq 'O';
            if @platform[$next][$j] eq '.' {
                for $next..$i-1 -> $n {
                    @platform[$n][$j] = @platform[$n+1][$j];
                }
                @platform[$i][$j] = '.';
            }
        }
    }
}


say "\nAfter tilting:";
.join.say for @platform;

my $load = 0;
for @platform.kv -> $i, @row {
    for @row.kv -> $j, $sym {
        if $sym eq 'O' {
            $load += (@platform - $i);
        }
    }
}
say "\nTotal load: $load";
