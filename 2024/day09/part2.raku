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
            my $found = False;
            for $free-list.reverse -> $free {
                last if $free[0] < $block[0] + $block[1];
                if $block[0] + $block[1] == $file[0] {
                    $free[1] += $file[1];
                    $found = True;
                    last;
                }
            }
            my $old = [$file[0], $file[1]];
            $file[0] = $block[0];
            $block[0] += $file[1];
            $block[1] -= $file[1];
            if $block[1] == 0 {
                $free-list.splice($i, 1);
            }
            $free-list.push($old) unless $found;
            if $debug {
                say "now files: {$files.raku}; free-list: {$free-list.raku}" if $debug > 1;
                say picture($files, $free-list);
            }
        }
    }
    my $checksum = [+] $files.kv.map: -> $i, $file { $i * m-to-n($file[0], $file[0] + $file[1]) };
    say $checksum;
}

sub scan($block is copy) {
    $block ~= '0' unless $block.chars %% 2;
    my $pos = 0;
    my (@files,@free-list);
    for $block.comb -> $data, $free {
        @files.push([$pos, +$data]);
        $pos += $data;
        @free-list.push([$pos, +$free]) if $free > 0;
        $pos += $free;
    }
    return @files, @free-list;
}

# sum of the consecutive integers from m up to but not including n
sub m-to-n($m, $n) {
    return ($n * ($n - 1) - $m * ($m - 1)) div 2;
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
