#!/usr/bin/env raku
unit sub MAIN($input, :$debug = False);

my ($map, $instructions) = $input.IO.slurp.split("\n\n")».split("\n");

my @map = $map.cache».comb».Array.Array;
$instructions .= join;

# find starting position of robot
my ($i,$j) = @map».grep(* eq '@',:kv).grep(*==2, :kv)[0,1;0];

my %dirs = '^' => [-1,0], '>' => [0,1], 'v' => [1,0], '<' => [0,-1];

sub move($i, $j, $dir) {
    return ($i, $j) unless can-move($i, $j, $dir);
    my ($di, $dj) = %dirs{$dir};
    my ($ni, $nj) = ($i, $j) Z+ ($di,$dj);
    my $block = @map[$ni;$nj];
    if $block ne '.' {
        move($ni, $nj, $dir);
        if $block eq '[' && $dir (elem) ('^', 'v') {
            move($ni, $nj+1, $dir);
        } elsif $block eq ']' && $dir (elem) ('^', 'v') {
            move($ni, $nj-1, $dir);
        }
    }
    @map[$ni;$nj] = @map[$i;$j];
    @map[$i;$j] = '.';
    return $ni,$nj;
}

sub can-move($i, $j, $dir) {
    die "unrecognized direction '$dir'" unless %dirs{$dir}:exists;
    my ($di, $dj) = %dirs{$dir};
    my ($ni, $nj) = ($i, $j) Z+ ($di,$dj);
    return False if @map[$ni;$nj] eq '#';
    return True if @map[$ni;$nj] eq '.';
    my $result = can-move($ni, $nj, $dir);
    if ($result) {
       if @map[$ni;$nj] eq '['  && $dir (elem) ( '^', 'v' ) {
           $result &&= can-move($ni, $nj+1, $dir);
       } elsif @map[$ni;$nj] eq ']'  && $dir (elem) ( '^', 'v' ) {
           $result &&= can-move($ni, $nj-1, $dir);
       }
    }
    return $result;
}


for $instructions.comb -> $dir {
    ($i,$j) = move($i, $j, $dir);
}

{ .join.say for @map } if $debug;
my $part1 = 0;
for @map.kv -> $i, @row {
    for @row.kv -> $j, $sym {
        $part1 += 100*$i+$j if $sym eq 'O';
    }
}
say $part1;

# construct new map for part2
my %expand = '@' => '@.', '#' => '##', '.' => '..', 'O' => '[]';
@map = $map».comb».map({%expand{$_}})».join».comb».Array.Array;
($i,$j) = @map».grep(* eq '@',:kv).grep(*==2, :kv)[0,1;0];

{ .join.say for @map } if $debug;

for $instructions.comb -> $dir {
    ($i,$j) = move($i, $j, $dir);
}

{ .join.say for @map } if $debug;

my $part2 = 0;
for @map.kv -> $i, @row {
    for @row.kv -> $j, $sym {
        $part2 += 100*$i+$j if $sym eq '[';
    }
}
say $part2;
