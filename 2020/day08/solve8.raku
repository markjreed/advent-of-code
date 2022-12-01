#!/usr/bin/env raku
unit sub MAIN($input-file, :$debug=False);

grammar HaltCode {
   token TOP { <instruction>+ %% \n }
   token instruction {
    <mnemonic> \s+ <signed-int>
   }
   proto token mnemonic {*}
   token mnemonic:sym<nop> { <sym> }
   token mnemonic:sym<acc> { <sym> }
   token mnemonic:sym<jmp> { <sym> }

   token signed-int {
     <[+-]> \d+
   }
}

class HaltCode-Actions {
    method TOP($/) {
       make $<instruction>.map: *.made
    }

    method instruction($/) {
       make [$<mnemonic>.Str, $<signed-int>.Int]
    }
}

my $text = $input-file.IO.slurp;
my @program = HaltCode.parse($text, actions=>HaltCode-Actions).made;

role Halted {
  has $.halted = True;
}

sub run(@program) {
  my ($acc, $pc, @seen) = 0, 0, [];
  while ($pc < @program && !@seen[$pc]) {
    @seen[$pc] = True;
    my ($op, $arg) = @program[$pc];
    say "PC: $pc, INS: $op $arg" if $debug;
    given $op {
      when 'acc' { $acc += $arg; $pc += 1 }
      when 'nop' { $pc += 1 }
      when 'jmp' { $pc += $arg }
    }
  }
  $acc but Halted($pc >= @program);
}

my $result = run(@program);
say "First run: $result";
my %swap = 'jmp' => 'nop', 'nop' => 'jmp';
for ^@program -> $pc {
  next if @program[$pc][0] eq 'acc';
  @program[$pc][0] = %swap{@program[$pc][0]};
  $result = run(@program);
  if $result.halted  {
    say "Halted with $result after changing instruction $pc"
  }
  @program[$pc][0] = %swap{@program[$pc][0]};
}
