#!/usr/bin/env raku
unit sub MAIN($input);

my @program = $input.IO.lines.map(|*.split(',')».Int).Array;

my %opcodes = ADD => 1, MUL => 2, HALT => 99;

sub run($a, $b, @program) {
    my @memory = @program;
    my $ip = 0;
    @memory[1..2] = $a, $b;
    loop {
        my $opcode = @memory[$ip];
        given $opcode {
           when %opcodes<HALT> { last; }
           when %opcodes<ADD> {
               my ($addr1, $addr2, $sum) = @memory[$ip+1..$ip+3];
               @memory[$sum] = @memory[$addr1] + @memory[$addr2];
               $ip += 4;
           }
           when %opcodes<MUL> {
               my ($addr1, $addr2, $product) = @memory[$ip+1..$ip+3];
               @memory[$product] = @memory[$addr1] * @memory[$addr2];
               $ip += 4;
           }
           default { warn "Unknown opcode $opcode at address $ip"; }
        }
    }
    return @memory[0];
}

# part 1
say run(12, 2, @program);

# part 2
for (^100) X (^100) -> ($a, $b) {
    if run($a, $b, @program) == 19690720 {
        say 100*$a + $b;
        last;
    }
}
