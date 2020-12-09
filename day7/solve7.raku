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
        #make { count => $<count>.Int, color => $<colored-bag>.made };
        make $<colored-bag>.made;
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
sub build-tree($outer, $inner) {
  for $inner -> $color {
    %can-be-in{$color} ||= [].SetHash;
    %can-be-in{$color}{$outer} = True;
    build-tree($outer, $rules{$color});
  }
}
for $rules.kv -> $out, $in {
  build-tree($out, $in);
}

say "Shiny gold bags can be in {+%can-be-in{'shiny gold'}} different colors."
