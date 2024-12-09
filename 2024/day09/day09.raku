#!/usr/bin/env raku
for lines() -> $block {
    my @memory = expand-block($block).comb.Array;
    my $i = 0;
    my $j = +@memory - 1;
    my $checksum = 0;
    my $id = 0;
    while $i < $j {
        #say @memory.join;
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
    $checksum = [+] @memory.kv.map(-> $i,$c {$i * ($c eq '.' ?? 0 !! $c) });
    say "$checksum";
}

sub expand-block($block is copy) {
    $block ~= '0' unless $block.chars %% 2;
    my $id = 0;
    my $result = '';
    for $block.comb -> $data, $free {
        $result ~= ($id x $data) ~ ('.' x $free);
        $id++;
    }
    return $result;
}
