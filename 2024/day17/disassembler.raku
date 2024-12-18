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
    sub adv($operand) { say "adv({combo($operand)})"; }
    sub bxl($operand) { say "bxl($operand)": }
    sub bst($operand) { say "bst({combo($operand)})"; }
    sub jnz($operand) { say "jnz($operand)"; }
    sub bxc($operand) { say "bxc($operand)"; }
    sub out($operand) { say "out({combo($operand)})"; }
    sub bdv($operand) { say "bdv({combo($operand)})"; }
    sub cdv($operand) { say "cdv({combo($operand)})"; }
];

for @code -> $opcode, $operand {
    @instructions[$opcode]($operand);
}
exit;

