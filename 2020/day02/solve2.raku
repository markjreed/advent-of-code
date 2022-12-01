#!/usr/bin/env raku
unit sub MAIN($input-file, Int :$part=1);

say +$input-file.IO.lines.grep: {
  my ($min, $max, $letter, $pass) = @( m{ (\d+) \- (\d+) \s+ (\S) \: \s+ (\w+) } );
  $part == 1 ??  ($min <= +$pass.comb.grep(~$letter) <= $max) 
             !!  ($pass.comb[$min-1], $pass.comb[$max-1]).grep(~$letter) == 1
}

