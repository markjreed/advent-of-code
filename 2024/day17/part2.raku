#!/usr/bin/env raku
unit sub MAIN($input);

my @code;
for $input.IO.lines {
    if m/'Program:' \s* ( <[0..7,]> + )/ {
        @code = $0.split(',').map(+*);
        last;
    }
}

sub one-round($a is copy) {
     my $b = ($a +& 7) +^ 2;
     my $c = $a +> $b;
     $b +^= $c;
     $a +>= 3;
     $b +^= 7;
     return $b +& 7;
}

my $a = 0;
while @code {
    my $target = @code.pop;
    for (8 * $a) ..^ (8 * $a + 8) -> $try {
        if one-round($try) == $target {
            $a = $try;
            last;
        }
    }
}
say $a;
