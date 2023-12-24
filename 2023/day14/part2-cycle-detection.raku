#!/usr/bin/env raku
unit sub MAIN($input);

my @start = $input.IO.lines».comb».Array.Array;

my @tortoise  = @start».clone».Array.clone.Array;
my @hare      = @start».clone».Array.clone.Array;

my @platform := @tortoise;
my $tortoise = load();

@platform := @hare;
cycle();
cycle();
my $hare = load();

while $tortoise != $hare {
    @platform := @tortoise;
    cycle();
    $tortoise = load();
    @platform := @hare;
    cycle();
    cycle();
    $hare = load();
}

my $μ = 0;
@tortoise = @start».clone».Array.clone.Array;
@platform := @tortoise;
$tortoise = load();
while $tortoise != $hare {
    @platform := @tortoise;
    cycle();
    $tortoise = load();
    @platform := @hare;
    cycle();
    $hare = load();
    $μ++;
}

my $λ = 1;
@platform := @tortoise;
cycle();
$hare = load();
while $tortoise != $hare {
    @platform := @hare;
    cycle();
    $hare = load();
    $λ++;
}

say "Found cycle: μ=$μ, λ=$λ.";

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
