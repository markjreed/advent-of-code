#!/usr/bin/env raku
use MONKEY-SEE-NO-EVAL;
my @grid = lines();

say [+] ([Z] @grid».words)».reverse.map: -> ($op, *@args) {
    EVAL "[$op](@args)";
}

my (@args, $part2);
for ([Z] @grid».flip».comb)».join {
    if /^ \s* ( \d+ ) ? \s* ( <[+*]> ) ? \s* $/ {
        if ($0) {
            @args.push(+$0);
        }
        if $1 {
            $part2 += EVAL "[$1](@args)";
            @args=();
        }
    }
}
say $part2;
