#!/usr/bin/env raku
unit sub MAIN($input-file, :$part = 1);
#use Grammar::Tracer;

grammar TicketNotes {
  token TOP { <field-list> "\n" <your-ticket> "\n" <nearby-tickets> }

  token field-list { <field-spec>+ %% "\n" }

  token field-spec { <field-name> \s* ':' \s* <range> \s* "or" \s* <range> }

  token field-name { <-[:]>+ }

  token range { <number> '-' <number> }

  token your-ticket { "your ticket:\n" <ticket> "\n" }

  token nearby-tickets { "nearby tickets:\n" <ticket-list> }

  token ticket-list { <ticket>+ %% "\n" }

  token ticket { <number>+ % "," }

  token number { \d+ }
}

class TicketNotes-Actions {

  method TOP($/) {
    make { rules => $<field-list>.made,
           your-ticket => $<your-ticket>.made,
           nearby-tickets => $<nearby-tickets>.made }
  }

  method field-list($/) { make %( $<field-spec>.map: *.made ) }

  method field-spec($/) { my $result = $<field-name>.made => $<range>.map: *.made;  make $result; }

  method field-name($/) { make ~ $/ }

  method range($/) { make Range.new(|($<number>.map: *.made)) }

  method your-ticket($/) { make $<ticket>.made }

  method nearby-tickets($/) { my $result = $<ticket-list>.made; make $result; }

  method ticket-list($/) { my $result = $<ticket>.map: *.made;  make $result; }

  method ticket($/) { my $result = $<number>.map: *.made;  make $result; }

  method number($/) { my $result = +$/;  make $result; }
}

my %notes = TicketNotes.parse($input-file.IO.slurp, actions => TicketNotes-Actions).made;

# check a value against a collection of ranges
sub in-range($value, @ranges) {
  for @ranges -> $range {
    return True if $value ~~ $range;
  }
  return False;
}

sub invalid-values(%rules, @ticket) {
  my @bogus;
  for @ticket».List.flat.clone -> $value {
    my $ok = False;
    for %rules.pairs -> $rule {
       $ok = True if in-range($value, $rule.value);
    }
    @bogus.push($value) unless $ok;
  }
  return @bogus;
}

given $part {
  when 1 {
    print "Found invaild values summing to ";
    say [+]( %notes<nearby-tickets>.map( -> $ticket {
      invalid-values(%notes<rules>, $ticket)
    })».List.flat)
  }
  when 2 {
    # get just the valid ticket
    my @valid = %notes<nearby-tickets>.grep( -> $ticket {
      0 == +invalid-values(%notes<rules>, $ticket)
    });
    my $fields = +@valid[0];
    say "{+@valid} nearby tickets are valid with $fields fields each";
    my %possible = %notes<rules>.keys.map:  * => (^$fields).SetHash;
    for ^$fields -> $field {
      for %notes<rules>.pairs -> $rule {
        for @valid -> $ticket {
          if !in-range($ticket[$field], $rule.value) {
             say "Column $field cannot be field {$rule.key}";
             %possible{$rule.key}.unset($field);
          }
        }
      }
    }
    for %possible.kv.clone -> $field1, $set1 {
      if +$set1 == 1 {
        for %possible.kv -> $field2, $set2 {
          if $field2 ne $field1 {
             $set2.unset($set1.keys[0])
          }
        }
      }
    }

    for %possible.kv -> $field, $set {
      if +$set == 1 {
        say "$field is column {$set.keys[0]}";
      }
    }
  }
}
