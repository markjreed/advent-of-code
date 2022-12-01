#!/usr/bin/env raku
unit sub MAIN($input-file);

grammar BagRules  {
   token TOP { <bag-rule>+ %% \n }
   token bag-rule {
    <colored-bag> \s+ 'contain' \s+ <bag-count-list> '.'
   }
   token colored-bag {
      <color> \s+ 'bag' 's'?
   }
   token count { \d+ }
   rule bag-count {\s*<count> <colored-bag>}
   token bag-count-list {
     <bag-count>+ %% ',' | <no-other-bags>
   }
   rule no-other-bags { 'no' 'other' 'bags' }
   rule color {<modifier> <hue>}
   token modifier { \w+ }
   token hue { \w+ }
}

class BagRules-Actions {
    method TOP($/) {
       make %( |($<bag-rule>.map: *.made) )
    }

    method bag-rule($/) {
      make {$<colored-bag>.made => |($<bag-count-list>.made)};
    }

    method colored-bag($/) {
      make $<color>.STR
    }

    method bag-count($/) {
        make { count => $<count>.Int, color => $<colored-bag>.made };
        #make $<colored-bag>.made;
    }

    method no-other-bags($/) {
        make []
    }

    method bag-count-list($/) {
      make $<bag-count>.map: *.made
    }
}
my $text = $input-file.IO.slurp;
my $rules = BagRules.parse($text, actions=>BagRules-Actions).made;

my %can-be-in;
my %contains;
sub summarize-tree($outer, $inner, $multiplier=1) {
  for $inner -> $bag-count {
    my ($color, $count) = $bag-count«color count»;
    %contains{$outer} += $multiplier * $count;
    %can-be-in{$color} ||= [].SetHash;
    %can-be-in{$color}{$outer} = True;
    summarize-tree($outer, $rules{$color}, $count*$multiplier);
  }
}
for $rules.kv -> $out, $in {
  summarize-tree($out, $in);
}

print "Shiny gold bags can be in {+%can-be-in{'shiny gold'}} different colors";
say " and must contain {%contains{'shiny gold'}} other bags.";
