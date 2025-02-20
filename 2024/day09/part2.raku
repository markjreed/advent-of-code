#!/usr/bin/env raku
unit sub MAIN($input-file, :$debug = 0);

for $input-file.IO.lines -> $block {
    my ($files, $free-list) = scan($block);
    if $debug {
        say "files: {$files.raku}; free-list: {$free-list.raku}" if $debug > 1;
        say picture($files, $free-list);
    }
    for $files.reverse -> $file {
        my ($i, $block) = $free-list.first({ .[0] < $file[0] && .[1] >= $file[1] }, :kv);
        if $block {
            my $free = $free-list.first({ .[0] + .[1] == $file[0] });
            my $old = [$file[0], $file[1]];
            $file[0] = $block[0];
            $block[0] += $file[1];
            $block[1] -= $file[1];
            if $block[1] == 0 {
                $free-list.splice($i, 1);
            }
            if $free {
                $free[1] += $old[1];
            } else {
                $free-list.push($old);
            }
            if $debug {
                say "now files: {$files.raku}; free-list: {$free-list.raku}" if $debug > 1;
                say picture($files, $free-list);
            }
        }
    }
    my $checksum = [+] $files.kv.map: -> $i, $file { $i * sum-n($file[1], :from($file[0])) };
    say $checksum;
}

sub scan($block is copy) {
    $block ~= '0' unless $block.chars %% 2;
    my $pos = 0;
    my (@files, @free-list);
    for $block.comb -> $data, $free {
        @files.push([$pos, +$data]);
        $pos += $data;
        @free-list.push([$pos, +$free]) if $free > 0;
        $pos += $free;
    }
    return @files, @free-list;
}

# sum of n consecutive integers
sub sum-n($n, :$from = 1) {
   return $n * ($n + 1) div 2 + $n * ($from - 1);
}

sub picture($files, $free-list) {
    my @picture = ' ' xx [+]($files»[1] + $free-list»[1]);
    for @$files.kv -> $i, $file {
        @picture[$file[0] ..^ $file[0]+$file[1]] »=» $i;
    }
    for @$free-list.kv -> $i, $block {
        @picture[$block[0] ..^ $block[0]+$block[1]] »=» '.';
    }
    return @picture.join;
}
