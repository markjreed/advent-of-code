#!/usr/bin/env raku
unit sub MAIN($input, $start=0);
my %registers = «A B C» »=>» 0;
my @code;

for $input.IO.lines {
    if m/'Register' \s+ ( <[ABC]> ) \s* ':' \s+ ( \d+ )/ {
        %registers{~$0} = +$1;
    } elsif m/'Program:' \s* ( <[0..7,]> + )/ {
        @code = $0.split(',')».Int;
    }
}

sub combo($operand) {
    return $operand if 0 <= $operand <= 3;
    return %registers{($operand - 4 + 'A'.ord).chr};
}

my ($pc, @output);

my @instructions = [
    sub adv($operand) { %registers<A> +>= combo($operand); }
    sub bxl($operand) { %registers<B> +^=  $$operand; }
    sub bst($operand) { %registers<B> = combo($operand) +& 7; }
    sub jnz($operand) { $pc = $operand unless %registers<A> == 0; }
    sub bxc($operand) { %registers<B> +^= %registers<C>; }
    sub out($operand) { @output.push(combo($operand) +& 7); }
    sub bdv($operand) { %registers<B> = %registers<A> +> combo($operand); }
    sub cdv($operand) { %registers<C> = %registers<A> +> combo($operand); }
];

sub run($match = False) {
    $pc = 0;
    @output = ();
    while 0 <= $pc < @code {
        my ($opcode, $operand) = @code[$pc..$pc+1];
        $pc += 2;
        @instructions[$opcode]($operand);
    }
    return @output;
}

say run.join(','); # part 1
