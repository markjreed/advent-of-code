#!/usr/bin/env raku
unit sub MAIN($input, $output-wire=Nil, $input-wire=Nil);

die "Need both output and input wires\n" if $output-wire && !$input-wire;

our %wires is export;

our %resolved;
sub resolve($wire) is export {
    if %resolved{$wire}:!exists {
        %resolved{$wire} = %wires{$wire}();
    }
    return %resolved{$wire};
}

sub make-num($num) {
    return sub { $num }
}

sub make-alias($wire) {
    return sub { resolve($wire) }
}

sub make-not-num($num) {
    return sub { +^ $num }
}

sub make-not-wire($wire) {
    return sub { +^ resolve($wire) }
}

sub make-binop($left, $op, $right) {
    return sub { 
        my $arg1 = ($left ~~ /^ \d+ $/) ?? +$left !! resolve($left);
        my $arg2 = ($right ~~ /^ \d+ $/) ?? +$right !! resolve($right);
        given $op {
            when 'AND'    { return $arg1 +& $arg2 }
            when 'OR'     { return $arg1 +| $arg2 }
            when 'LSHIFT' { return $arg1 +< $arg2 }
            when 'RSHIFT' { return $arg1 +> $arg2 }
        }
    }
}

for $input.IO.lines -> $line {
    my ($expr, $wire) = @($line ~~ / ^ ( .* \S) \s* '->' \s* ( \w+ ) $ /);
    my $sub = sub { die "Error! Unresolved wire $wire!"; };
    if $expr ~~ / ^ ( \d+ ) $ / {  $sub = make-num(+$0) }
    elsif $expr ~~ / ^ ( \w+ ) $ / {  $sub = make-alias(~$0) }
    elsif $expr ~~ / ^ 'NOT' \s* ( \d+ ) $ / { $sub = make-not-num(+$0) }
    elsif $expr ~~ / ^ 'NOT' \s+ ( \w+ ) $ / { $sub = make-not-wire(~$0) }
    elsif $expr ~~ / ^ ( \w+ ) \s+ ( 'AND' | 'OR' | 'LSHIFT' | 'RSHIFT' ) \s+ ( \w+ ) $ / { 
       my ($left, $op, $right) = @($/);
       $sub = make-binop($left, $op, $right);
    } else {
        say "Unrecognized line '$line' (expr = '$expr')";
    }
    %wires{$wire} = $sub;
}

if ($output-wire) {
    my $result = resolve($output-wire);
    say $result;
    %wires{$input-wire} = make-num($result);
    %resolved = ();
    say resolve($output-wire);
} else {
    for %wires.keys -> $wire {
        say "$wire: {resolve $wire}";
    }
}
