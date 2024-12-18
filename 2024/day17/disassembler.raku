#!/usr/bin/env raku
unit sub MAIN($input, $start=0);
my %registers = «A B C» »=>» 0;
my $pc = 0;
my @code;

for $input.IO.lines {
    if m/'Register' \s+ ( <[ABC]> ) \s* ':' \s+ ( \d+ )/ {
        %registers{~$0} = +$1;
    } elsif m/'Program:' \s* ( <[0..7,]> + )/ {
        @code = $0.split(',').map(+*);
    }
}

sub combo($operand) {
    return $operand if 0 <= $operand <= 3;
    return ($operand - 4 + 'A'.ord).chr;
}

my Bool $written = False;
my @output;
sub write($value) {
    @output.push($value);
}

my @instructions = [
    sub adv($pc,$operand) { say "$pc: A >>= {combo($operand)}"; }
    sub bxl($pc,$operand) { say "$pc: B ^= $operand": }
    sub bst($pc,$operand) { say "$pc: B = {combo($operand)} & 7"; }
    sub jnz($pc,$operand) { say "$pc: if A then $operand"; }
    sub bxc($pc,$operand) { say "$pc: B ^= C"; }
    sub out($pc,$operand) { say "$pc: out({combo($operand)} & 7)"; }
    sub bdv($pc,$operand) { say "$pc: B = A >> {combo($operand)}"; }
    sub cdv($pc,$operand) { say "$pc: C = A >> {combo($operand)}"; }
];

for @code.kv -> $pc, $opcode, $pc-plus1, $operand {
    @instructions[$opcode]($pc, $operand);
}
exit;

