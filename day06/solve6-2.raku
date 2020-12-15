#!/usr/bin/env raku
unit sub MAIN($input-file, :$validity-test=1);
say [+] $input-file.IO.lines(nl-in => "\n\n").map: -> $group {
    say "group: [ $group ]";
    my @all = ('a'..'z').grep: { given rx/$_/ { ?(all($group.lines) ~~ $_) }};
    +@all;
};
