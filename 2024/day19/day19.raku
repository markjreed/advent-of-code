#!/usr/bin/env raku
unit sub MAIN($input);

my (@available, $part1, $part2);
for $input.IO.lines {
   @available = .split(/ ',' \s* /) unless @available;
   if / . / {
       if my $count = can-make($_) {
          $part1++;
          $part2 += $count;
       }
   }
}
say $part1;
say $part2;

my %can-make;
sub can-make($pattern) {
    unless %can-make{$pattern}:exists {
        my $count = 0;
        for @available -> $towel {
            if $pattern eq $towel {
                $count++;
            } elsif $pattern.starts-with($towel) {
                $count += can-make(substr($pattern, $towel.chars));
            }
        }
        %can-make{$pattern} = $count;
    }
    return %can-make{$pattern};
}
