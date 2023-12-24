#!/usr/bin/env raku
unit sub MAIN($input);

my @platform = $input.IO.lines».comb».Array.Array;
# Found cycle: μ=88, λ=3

my $n = 0;
say "$n: {load}";
for ^102 {
    cycle();
    say "{++$n}: {load}";
}

sub cycle() {
    for ^4 {
       tilt();
       rotate()
    }
}

sub tilt() {
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
}


sub rotate() {
    @platform = ([Z] @platform)».reverse».Array.Array;;
}

sub load() {
    my $load = 0;
    for @platform.kv -> $i, @row {
        for @row.kv -> $j, $sym {
            if $sym eq 'O' {
                $load += (@platform - $i);
            }
        }
    }
    return $load;
}
