#!/usr/bin/env raku
use v6.e.PREVIEW; # needed for @matrix[||@indexes]

unit sub MAIN($input);

my @map = $input.IO.lines.map(*.comb».Int.Array);
my $height = +@map;
my $width = +@map[0];

# convert to graph form
my @vertices = ^($width * $height);
sub vertex($i, $j) { $i * $width + $j }
sub coords($vertex) { $vertex.polymod($width).reverse }

my %edges = @vertices.map: * => [ ]; 
for @map.kv -> $i, @row {
    for @row.kv -> $j, $level {
        my $u = vertex($i, $j);
        for ($i + 1, $j), ($i, $j + 1) -> ($ni, $nj) {
            if $ni < $height && $nj < $width && abs($level - @map[$ni][$nj]) == 1 {
                my $v = vertex($ni, $nj);
                if $level < @map[$ni][$nj] {
                    %edges{$u}.push: $v;
                } else {
                    %edges{$v}.push: $u;
                }
            }
        }
    }
}

# create a list of virtual hikers for each trail head, initial just
# one each at the head. as they move, we only remember where they started and
# where they are; their presence in the list is enough to indicate that they
# took a unique path, which we don't have to reconstruct.
my %trail-heads = 
    @vertices.grep(-> $v { @map[||coords($v)] == 0 }, :k).map: { $_ => [ $_, ] };

my %scored;
my ($part1, $part2) »=» 0;
my $done = False;
while !$done {
    $done = True;
    for %trail-heads.kv -> $start, @hikers {
        my (@new, @done);
        for @hikers.kv -> $i, $u {
            if my @v = @(%edges{$u}) {
                # the hiker can move, so we're not done
                $done = False;

                # move them
                %trail-heads{$start}[$i] = @v.shift;

                # if there's more than one option, clone them to append later
                for @v -> $v {
                    @new.push($v)
                }
            } else {
                # this hiker has reached a dead end; mark them for removal
                @done.push($i);

                # but if the dead end is at height 9, score it first
                if @map[||coords($u)] == 9 {
                    $part2++;
                    $part1++ unless %scored{"$start,$u"};
                    %scored{"$start,$u"} = True;
                }
            }
        }
        # bookkeeping - we didn't modify the array while iterating over it,
        # so we apply the changes now. First: delete the hikers that hit
        # dead ends.
        
        # removal is by index so we keep track of how many we've deleted and
        # adjust later indexes accordingly
        my $removed = 0;

        # we also need to process the indexes in order for this approach to work
        for @done.sort -> $i {
            %trail-heads{$start}.splice($i - $removed, 1);
            $removed++;
        }

        # now append any new hiker clones
        %trail-heads{$start}.append(@new);
    }
}
say $part1;
say $part2;
