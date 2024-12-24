#!/usr/bin/env raku
unit sub MAIN($input);

my %wires;

sub true { 1; }

sub false { 0; } 

sub make-binop($op, $wire1, $wire2) {
    return sub {
        my $left = %wires{$wire1}();
        return unless defined $left;
        my $right = %wires{$wire2}();
        return unless defined $right;
        given $op {
            when 'AND' { return $left +& $right }
            when 'OR' { return $left +| $right }
            when 'XOR' { return $left +^ $right }
        }
    }
}

my regex wire { <[a..z]> <[a..z0..9]>* }
my regex bitval { <[01]> }
my regex input { <wire> \s* ':' \s* <bitval> }
my regex op { 'AND' | 'OR' | 'XOR' }
my regex expr { <wire> \s+ <op> \s+ <wire> \s* '->' \s* <wire> };
       
for $input.IO.lines {
    if m/<input>/ {
        my $bitval = $<input><bitval>;
        %wires{$<input><wire>} = ?+$<input><bitval> ?? &true !! &false;
    } elsif m/<expr>/ {
        %wires{$<expr><wire>[2]} = 
            make-binop($<expr><op>, $<expr><wire>[0], $<expr><wire>[1]);
    }
}

my $z = 0;
for %wires.keys.grep(*.starts-with: 'z').sort.reverse -> $wire {
    $z = ($z +< 1) +| %wires{$wire}();
}
say $z;
