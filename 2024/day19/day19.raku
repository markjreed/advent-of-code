#!/usr/bin/env raku
unit sub MAIN($input);

my (@available, $part1);
for $input.IO.lines {
   @available = .split(/ ',' \s* /) unless @available;
   if / . / {
       $part1++ if can-make($_);
   }
}
say $part1;

my %can-make;
sub can-make($pattern) {
    unless %can-make{$pattern}:exists {
        for @available -> $towel {
            if $pattern eq $towel {
                %can-make{$pattern} = True;
                last;
            }
            if $pattern.starts-with($towel) &&
                can-make(substr($pattern, $towel.chars)) {
                %can-make{$pattern} = True;
                last;
            }
        }
        %can-make{$pattern} //= False;
    }
    return %can-make{$pattern};
}
