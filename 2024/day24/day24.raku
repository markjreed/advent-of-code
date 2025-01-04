#!/usr/bin/env raku
unit sub MAIN($input);

my (%wires, $x, $y, $z, $tracing, %gates);

sub true { 1; }

sub false { 0; } 

sub make-binop($op, $wire1, $wire2) {
    return sub {
        if $tracing {
            %gates{$wire1} = True;
            %gates{$wire2} = True;
        }
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
        my $wire = ~$<input><wire>;
        my $bitval = ~$<input><bitval>;
        if $wire.starts-with('x') {
            $x = $bitval ~ $x;
        } elsif $wire.starts-with('y') {
            $y = $bitval ~ $y;
        }
        %wires{$<input><wire>} = ?+$<input><bitval> ?? &true !! &false;
    } elsif m/<expr>/ {
        %wires{$<expr><wire>[2]} = 
            make-binop($<expr><op>, $<expr><wire>[0], $<expr><wire>[1]);
    }
}

$z = 0;
for %wires.keys.grep(*.starts-with: 'z').sort.reverse -> $wire {
    $z = ($z +< 1) +| %wires{$wire}();
}
my $z2 = $z.base(2);
say $z; # part 1
say "  x: $x ({$x.parse-base(2)})";
say "  y: $y ({$y.parse-base(2)})";
my $sum = "\%0{$z2.chars}b".sprintf($x.parse-base(2) + $y.parse-base(2));
say "  z:$z2";
say "sum:$sum";
for ($z2.flip.comb Z, $sum.flip.comb).kv -> $i, ($a, $b) {
    if $a != $b {
        my $bit = "z%02d".sprintf($i);
        $tracing = True;
        %gates = ();
        my $value = %wires{$bit}();
        say "error in $bit, which uses gates {%gates.keys.sort.join: ','}";
    }
}
#say " x: $x"; 
#say "+y: $y";
#say "=:\%0{$x.chars}b".sprintf([+] ($x,$y)».parse-base(2));
#say "z:\%0{$x.chars}b".sprintf($z);
