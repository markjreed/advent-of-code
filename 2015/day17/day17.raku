#!/usr/bin/env raku
unit sub MAIN($input, $volume=150);

my @containers = $input.IO.lines;

my @options = @containers.combinations.grep(*.sum == $volume);

say +@options;

my $min-size = +@options.min(+*);

say +@options.grep: +* == $min-size;
