#!/usr/bin/env raku
unit sub MAIN($input-file, $steps, :$debug = False);

my %stones;
for $input-file.IO.lines[0].words».Int -> $stone {
    %stones{$stone}++;
}

for ^$steps -> $gen {
    my %new;
    for %stones.kv -> $stone, $count {
        given $stone {
            when $_ == 0  { 
                %new{1} += $count;
            }
            when .chars %% 2 { 
                %new{ +.substr(0, .chars div 2) } += $count;
                %new{ +.substr(.chars div 2) } += $count;
            }
            default {
                %new{$_ * 2024} += $count;
            }
        }
    }
    %stones = %new;
    say "$gen:{[+] %stones.values}" if $debug;
}
print "$steps:" if $debug;
say [+] %stones.values;
