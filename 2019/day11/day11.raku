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

my @dirs = (0, -1), (1, 0), (0, 1), (-1, 0);

sub run($color) {
    my ($x, $y) »=» 0;
    my $dir = 0;
    my $key = "$x,$y";

    my %color = $key => $color;
    my $robot = Instance.new(:@program);
    while $robot.running {
        my $color = %color{$key}:exists ?? %color{$key} !! 0;
        %color{$key} = $robot.run($color);
        given $robot.run(%color{$key}) {
            when 0 { $dir = ( $dir - 1 ) % @dirs; }
            when 1 { $dir = ( $dir + 1 ) % @dirs; }
        }
        ($x, $y) Z+= @(@dirs[$dir]);
        $key = "$x,$y";
    }
    return %color;
}

say +run(0);
my %result = run(1);
my ($min-x, $min-y) »=» Inf;
my ($max-x, $max-y) »=» -Inf;
for %result.keys -> $key {
    my ($x, $y) = $key.split(',')».Int;
    if $x < $min-x { $min-x = $x }
    elsif $x > $max-x { $max-x = $x }
    if $y < $min-y { $min-y = $y }
    elsif $y > $max-y { $max-y = $y }
}
for $min-y .. $max-y -> $y {
    for $min-x .. $max-x -> $x {
        my $key = "$x,$y";
        my $color = %result{$key}:exists && defined(%result{$key}) ?? %result{$key} !! 0;
        print($color == 1 ?? 'X' !! ' ');
    }
    say '';
}
