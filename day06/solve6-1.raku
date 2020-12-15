#!/usr/bin/env raku
unit sub MAIN($input-file, :$validity-test=1);
say [+] $input-file.IO.lines(nl-in => "\n\n").map: -> $group {
    +(set $group.comb.grep( /<[a..z]>/ ));
}
