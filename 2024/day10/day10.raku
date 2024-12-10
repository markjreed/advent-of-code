#!/usr/bin/env raku
use v6.e.PREVIEW;

unit sub MAIN($input);

my @map = $input.IO.lines.map(*.comb».Int.Array);
my $height = +@map;
my $width = +@map[0];

my @vertices = @map.kv.map(-> $i, @row { 
    @row.kv.map( -> $j, $cell { 
        $i * $width + $j;
    }).Array
});
my @coords = (^$height X ^$width);

my %edges; 
for @map.kv -> $i, @row {
    for @row.kv -> $j, $level {
        my $u = @vertices[$i][$j];
        %edges{$u} //= [];
        for ($i+1,$j),($i,$j+1) -> ($ni, $nj) {
            if 0 <= $ni < $height && 0 <= $nj < $width && 
                abs(@map[$i][$j] - @map[$ni][$nj]) == 1 {
                my $v = @vertices[$ni][$nj];
                %edges{$v} //= [];
                if @map[$i][$j] < @map[$ni][$nj] {
                    #say "$i,$j {@map[$i][$j]} -> $ni,$nj {@map[$ni][$nj]}";
                    %edges{$u}.push: $v;
                } else {
                    %edges{$v}.push: $u;
                }
            }
        }
    }
}

my @trail-heads = @coords.grep(-> ($i,$j) { @map[$i][$j] == 0 }, :k);

my %paths = @trail-heads Z=> @trail-heads.map: { [$_,] };;

my %scored;
my ($part1, $part2) »=» 0;
my $done = False;
while !$done {
    $done = True;
    for %paths.kv -> $start, @heads {
        my (@new, @done);
        for @heads.kv -> $i, $u {
            my @v = @(%edges{$u});
            if !+@v {
                @done.push($i);
                if @map[||@coords[$u]] == 9 {
                    $part2++;
                    $part1++ unless %scored{"$start,$u"};
                    %scored{"$start,$u"} = True;
                }
            } else {
                $done = False;
                %paths{$start}[$i] = @v.shift;
                for @v -> $v {
                    @new.push($v)
                }
            }
        }
        my $removed = 0;
        for @done.sort -> $i {
            %paths{$start}.splice($i - $removed, 1);
            $removed++;
        }
        %paths{$start}.append(@new);
    }
}
say $part1;
say $part2;
