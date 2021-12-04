#!/usr/bin/env raku
my $input = $*ARGFILES.slurp;

my ($calls, @boards) = $input.split("\n\n");

my @calls = $calls.split: ',';

#say @boards.join("\n\n");
my ($score, %winners);
for @calls -> $ball {
  @boards .= map: { .subst( /«$ball»/, '*', :g) };
  #say "After $ball:";
  #say @boards.join("\n\n");
  for @boards.kv -> $i, $board {
    next if %winners{$i};
    if $board ~~ /(^ || \n) \s* (\* <[\x20]>+)**4 \* / or
       $board ~~ / ( \* (\s+ \S+)**4 \s+ )**4 \* / {
        $score = $ball * [+]($board ~~ m:g/ \d+ /);
        %winners{$i} = True;
    }
  }
}
say "Final score was $score";
