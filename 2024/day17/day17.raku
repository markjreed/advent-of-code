#!/usr/bin/env raku
unit sub MAIN($input);
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
    return %registers{($operand - 4 + 'A'.ord).chr};
}

my Bool $written = False;
my @output;
sub write($value) {
    @output.push($value);
}

my @instructions = [
    sub adv($operand) { %registers<A> div= (1 +< combo($operand)); }
    sub bxl($operand) { %registers<B> +^=  $$operand; }
    sub bst($operand) { %registers<B> = combo($operand) +& 7; }
    sub jnz($operand) { $pc = $operand unless %registers<A> == 0; }
    sub bxc($operand) { %registers<B> +^= %registers<C>; }
    sub out($operand) { write(combo($operand) +& 7); }
    sub bdv($operand) { %registers<B> = 
                        %registers<A> div (1 +< combo($operand)); }
    sub cdv($operand) { %registers<C> = 
                        %registers<A> div (1 +< combo($operand)); }
];

sub run($match = False) {
    $pc = 0;
    @output = ();
    while 0 <= $pc < @code {
        my $output = +@output;
        my ($opcode, $operand) = @code[$pc..$pc+1];
        $pc += 2;
        @instructions[$opcode]($operand);
        if $match && 
           @output > $output && @output[$output] != @code[$output] {
            return;
        }
    }
    return @output;
}

say run.join(','); # part 1
my %copy = %registers;
my @out = run;
my $a = -1;
while @out !eqv @code {
    $a += 1;
    print "$a      \r";
    %registers = %copy;
    %registers<A> = $a;
    @out = run(True);
}
say $a;
