#!/usr/bin/env raku

say [*](do given ([Z+] $*ARGFILES.lines.map(*.comb.map(*.subst(0,-1)))).map({+($_>0)}).join {
  .parse-base(2), .trans('01'=>'10').parse-base(2)
});
