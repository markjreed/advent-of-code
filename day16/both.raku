#!/usr/bin/env raku
my $hex = slurp.chomp;
my @bits = $hex.parse-base(16).base(2).comb;
# leading 0's matter!
@bits.unshift(0) while @bits < $hex.chars * 4;

my $versum = 0;

sub parse-packet(@bits, $level=0) {
  my $count = +@bits;
  return Nil unless +@bits > 6;
  my $version = @bits.splice(0,3).join.parse-base(2) // return Nil;
  $versum += $version;
  my $type = @bits.splice(0,3).join.parse-base(2);
  given $type {
    when 4 { # literal
      my $digits = 0;
      my $value = 0;
      my $continue = 1;
      while $continue {
        $continue = +@bits.shift;
        my $digit = @bits.splice(0,4).join.parse-base(2);
        $digits++;
        $value = $value * 16 + $digit;
      }
      return [$value];
    }
    default { # operator
      my $length-type = +@bits.shift;
      my @operation = do given $type {
        when 0 { '+' }
        when 1 { '*' }
        when 2 { 'min' }
        when 3 { 'max' }
        when 5 { '>' }
        when 6 { '<' }
        when 7 { '=' }
        default { $type }
      }
      given $length-type {
        when 0 {
          my $bit-size = @bits.splice(0,15).join.parse-base(2);
          my @child-bits = @bits.splice(0,$bit-size);
          while @child-bits {
            if (my $packet = parse-packet @child-bits).defined {
              @operation.push: $packet;
            } else {
              last;
            }
          }
        }
        when 1 {
          my $packet-count = @bits.splice(0,11).join.parse-base(2);
          for ^$packet-count {
            if (my $packet = parse-packet @bits).defined {
              @operation.push: $packet;
            } else {
              last;
            }
          }
        }
        default {
          say "Huh?";
        }
      }
      return @operation;
    }
  }
}

sub evaluate(@expr) {
  if +@expr == 1 {
    return @expr[0];
  }
  given @expr[0] {
    when '+' {  [+] @expr.splice(1).map: { evaluate $_ } }
    when '*' {  [*] @expr.splice(1).map: { evaluate $_ } }
    when '<' {  +([<] @expr.splice(1).map: { evaluate $_ }) }
    when '>' {  +([>] @expr.splice(1).map: { evaluate $_ }) }
    when '=' { +([==] @expr.splice(1).map: { evaluate $_ }) }
    when 'min' {  @expr.splice(1).map( { evaluate $_ } ).min }
    when 'max' {  @expr.splice(1).map( { evaluate $_ } ).max }
  }
}

my $tree = parse-packet(@bits);
say "version sum=$versum";
say evaluate($tree);

