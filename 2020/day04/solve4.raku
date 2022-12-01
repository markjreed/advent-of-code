#!/usr/bin/env raku
unit sub MAIN($input-file, :$validity-test=1);

my %checks = (
  byr => { m[ ^ \d**4 $ ] && 1920 <= $_ <= 2002 },
  iyr => { m[ ^ \d**4 $ ] && 2010 <= $_ <= 2020 },
  eyr => { m[ ^ \d**4 $ ] && 2020 <= $_ <= 2030 },
  hgt => {
    my ($value, $units) = @(m/ ^ (\d+) (cm|in) $ /);
    $value && $units && (
      ($units eq 'cm' && 150 <= $value <= 193) ||
      ($units eq 'in' &&  59 <= $value <= 76)
    ) },
  hcl => { / ^ '#' <[0..9a..f]>**6 $ / },
  ecl => { $_ eq any(«amb blu brn gry grn hzl oth») },
  pid => { m[ ^ \d**9  $] }
);

say +( $input-file.IO.lines(nl-in => "\n\n").map( {
  parse-passport($_) } ).grep:{ valid-passport($_) });

sub parse-passport($pp) {
  %( $pp.split( rx{ \s+ } ).map: { Pair.new( |.split(':') ) });
}

sub valid-passport(%data) {
  given $validity-test {
    when 1 { !(%data.keys (-) %checks.keys) }
    when 2 {
      all(%checks.kv.map: -> $key, $block {
        %data{$key}:exists && %data{$key}.&$block
      })
    }
  }
}
