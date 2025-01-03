#!/usr/bin/env raku
unit sub MAIN($input);

my @program = $input.IO.lines.map(|*.split(',').grep(*.chars)».Int).Array;

class Instance {
    constant MEMORY_SIZE = 100_000;
    has @!program is built;
    has @!memory;
    has $!ip = 0;
    has Bool $.running = True;
    has $!last-result;
    has $!relative-base = 0;

    my @keys = «NOP ADD MUL GET PUT JTRUE JFALSE LESS EQUAL REL»;
    my %opcodes = |@keys.pairs, 99 => 'HALT';

    my %params  = ADD => 3, MUL => 3, GET => 1, PUT => 1, JTRUE => 2,
                  JFALSE => 2, LESS => 3, EQUAL => 3, REL => 1, HALT => 0;

    method run(*@inputs) {
        unless @!memory {
            @!memory = [|@!program, |(0 xx MEMORY_SIZE - +@!program)];
        }

        loop {
            my ($opcode, @modes) = @!memory[$!ip].polymod(100,10,10);
            my $key = %opcodes{$opcode};
            my @params = @!memory[$!ip + 1 .. $!ip + %params{$key}];
            for @params.kv -> $i, $p is copy {
                given @modes[$i] {
                    when 0 { 
                        say "undefined \@{$p} at $!ip" unless defined @params[$i] := @!memory[$p];
                    }
                    when 2 { 
                        $p += $!relative-base;
                        say "undefined \@{$p} at $!ip" unless defined @params[$i] := @!memory[$p];
                    }
                }
            }
            $!ip += 1 + %params{$key};

            given $key {
               when 'HALT'   { $!running = False; return; }
               when 'ADD'    { @params[2] = @params[0] + @params[1]; }
               when 'MUL'    { @params[2] = @params[0] * @params[1]; }
               when 'GET'    { @params[0] = @inputs ?? @inputs.shift !! get; }
               when 'PUT'    { return $!last-result = @params[0]; }
               when 'JTRUE'  { $!ip = @params[1] if @params[0]; }
               when 'JFALSE' { $!ip = @params[1] unless @params[0]; }
               when 'LESS'   { @params[2] = +?(@params[0] < @params[1]); }
               when 'EQUAL'  { @params[2] = +?(@params[0] == @params[1]); }
               when 'REL'    { $!relative-base += @params[0]; }
               default { warn "Unknown opcode $opcode at address $!ip"; }
            }
        }
    }
}

for 1,2 -> $input {
    my $instance = Instance.new(:@program);
    say gather while $instance.running {
        my $output = $instance.run($input);
        take $output if $instance.running;
    }.join(',');
}
