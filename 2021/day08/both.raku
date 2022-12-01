#!/usr/bin/env raku
my @lines = [lines];
my @data = @lines».split(/ \s* '|' \s*/).List».&{.split(' ').List}.List;

# puzzle 1 - output digits with unique segment counts:
say +(@data».[1].flat.grep: *.chars == 2|3|4|7);

# puzzle 2 - decode the actual displays
my %segments = (
  0 => 'abcefg',
  1 => 'cf',
  2 => 'acdeg',
  3 => 'acdfg',
  4 => 'bcdf',
  5 => 'abdfg',
  6 => 'abdefg',
  7 => 'acf',
  8 => 'abcdefg',
  9 => 'abcdfg'
);

my $total = 0;
for @data ->  ($digits, $display) {
  my (%cipher, %digits);

  # get c and f candidates from the one
  %digits<1> = $digits.grep(*.chars == 2)[0];
  my $cf = %digits<1>.comb.Set;

  # find a from the seven
  %digits<7> = $digits.grep(*.chars == 3)[0];
  (%cipher«a»,) = %digits<7>.comb.grep: { $_ !⊂ $cf }

  # find b and d candidates from the four
  %digits<4> = $digits.grep(*.chars == 4)[0];
  my $bd = %digits<4>.comb.grep({ $_ !⊂ $cf }).Set;

  # find c (=> f) from the six
  %digits<6> = $digits.grep(*.chars == 6).grep({ my $diff = (['a'..'g'] (-) .comb); $diff ⊂ $cf && ( %cipher«c» = $diff.keys[0]) })[0];
  %cipher«f» = ($cf (-) %cipher«c»).keys[0];

  # and d (=> b) from the zero
  %digits<0> = $digits.grep(*.chars == 6).grep({ my $diff = (['a'..'g'] (-) .comb); $diff ⊂ $bd && ( %cipher«d» = $diff.keys[0]) })[0];
  %cipher«b» = ($bd (-) %cipher«d»).keys[0];

  # finally, find the three and use it to decode the remaining two segments
  my $acdf = (%cipher.«a c d f»).Set;
  %digits<3> = $digits.grep(*.chars == 5).grep({ my $diff = (.comb (-) $acdf); (+$diff == 1) && (%cipher«g» = $diff.keys[0])})[0];
  %cipher«e» = (['a'..'g'] (-) %cipher.values).keys[0];

  # now fill in the remaining digits
  for ^10 -> $digit {
    %digits{$digit} //= $digits.grep({ .comb (==) %segments{$digit}.comb.map({ %cipher{$_} }) })[0];

    # display lists on the right of the | are not necessarily in the same order, so sort
    %digits{$digit} .= &{ .comb.sort.join };
  }

  my %trans = %digits.invert.Hash;
  my $value = 0;
  for $display.map(*.comb.sort.join) -> $digit {
    $value = $value * 10 + %trans{$digit}
  }
  $total += $value
}
say $total;


# The decode logic:
# 1. Find the 1, with two segments lit. We know those are c and f.
# 2. Find the 7, with three segments: the one that is neither c nor f must be a.                SOLVED: a
# 3. Find the 4, with four segments:  the two that aren't c or f must be b and
#    d, though again we don't know the order.
# 4. There are three digits with six segments lit: 0 is missing d, 6 is missing
#    c, and 9 is missing e.  Find the one whose missing segment is one of our
#    candidates for c and f. That's the 6, and the segment it's missing is c,
#    which tells us the other one is f.                                                         SOLVED: a, c, f
# 5. Likewise, whichever six-semgent digit is missing one of our candidates for
#    b and d is the 0, and the segment it's missing is d, which tells us
#    the other one is b.                                                                        SOLVED: a, b, c, d, f
# 6. There are now only two letters left to figure out: e and g. Look for
#    a 5-segment digit with either of them where the other four are a,c,d, and
#    f, which we know.. That will be the 3, and the segment present will be g,
#    meaning the other one is e.                                                                SOLVED: a, b, c, d, e, f, g
