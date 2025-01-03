#!/usr/bin/env raku
unit sub MAIN($input);

my @program = $input.IO.lines.map(|*.split(',')».Int).Array;

my @keys = «NOP ADD MUL GET PUT JTRUE JFALSE LESS EQUAL»;
my %opcodes = |@keys.pairs, 99 => 'HALT';

my %params  = ADD => 3, MUL => 3, GET => 1, PUT => 1, JTRUE => 2, JFALSE => 2,
              LESS => 3, EQUAL => 3, HALT => 0;

sub run(@program) {
    my @memory = @program;
    my $ip = 0;
    loop {
        my ($opcode, @modes) = @memory[$ip].polymod(100,10,10);
        my $key = %opcodes{$opcode};
        my @params = @memory[$ip + 1 .. $ip + %params{$key}];
        for @params.kv -> $i, $p {
            if @modes[$i] == 0 {
                @params[$i] := @memory[$p]
            }
        }
        $ip += 1 + %params{$key};

        given $key {
           when 'HALT'   { last; }
           when 'ADD'    { @params[2] = @params[0] + @params[1]; }
           when 'MUL'    { @params[2] = @params[0] * @params[1]; }
           when 'GET'    { @params[0] = get().Int; }
           when 'PUT'    { say @params[0]; }
           when 'JTRUE'  { $ip = @params[1] if @params[0]; }
           when 'JFALSE' { $ip = @params[1] unless @params[0]; }
           when 'LESS'   { @params[2] = +?(@params[0] < @params[1]); }
           when 'EQUAL'  { @params[2] = +?(@params[0] == @params[1]); }
           default { warn "Unknown opcode $opcode at address $ip"; }
        }
    }
}

# part 1
run(@program);
