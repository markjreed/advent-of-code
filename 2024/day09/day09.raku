#!/usr/bin/env raku
for lines() -> $block {
    my @memory = expand-block($block);
    my $i = 0;
    my $j = +@memory - 1;
    my $checksum = 0;
    my $id = 0;
    while $i <= $j {
        while $i < @memory && @memory[$i] ne '.' {
            $checksum += $i * @memory[$i];
            $i++;
        }
        last if $i >= $j;
        while $j>=0 && @memory[$j] eq '.' {
            $j--;
        }
        last if $i >= $j;
        @memory[$i] = @memory[$j];
        $checksum += $i * @memory[$i];
        @memory[$j] = '.';
        $i++;
        $j--;
    }
    say $checksum;
}

sub expand-block($block is copy) {
    $block ~= '0' unless $block.chars %% 2;
    my $id = 0;
    my @result;
    for $block.comb -> $data, $free {
        @result.append( |($id xx $data), |('.' xx $free));
        $id++;
    }
    return @result;
}
