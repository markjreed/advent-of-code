#!/usr/bin/env raku
unit sub MAIN($input);

my @map = $input.IO.lines».comb».Array;

my $height = +@map;
my $width = +@map[0];

# what region each cell is in 
my @region = (Array) xx @map;

# things to determine about each region
my (@plant-type, @area, @perimeter, @sides);

# Identify all the regions. The plant type alone is not a unique
# identifier, since there can be multiple regions with the same type.
my $next = 0;
for @map.kv -> $i, @row {
    for @row.kv -> $j, $plant {
       my $region;
       for ($i-1,$j),($i,$j-1),($i,$j+1),($i+1,$j) -> ($ni,$nj) {
           if defined(@region[$ni;$nj]) && @map[$ni;$nj] eq $plant {
                  $region = @region[$ni;$nj];
                  last;
           }
       }
       if !defined($region) {
           $region = +@plant-type;
           @plant-type.push: $plant;
           @area.push: 0;
           @perimeter.push: 0;
           @sides.push: [];
       }
       set-region($i, $j, $region);
    }
}

# Now to find the areas and perimeters:
for @region.kv -> $i, @row {
    for @row.kv -> $j, $region {
        @area[$region]++;
        if $i == 0 {
           #say "top cell: adding edge above";
           add-edge($region, $i, $j, $i, $j+1);
        }
        if $j == 0 {
           #say "left cell: adding edge to left";
           add-edge($region, $i, $j, $i+1, $j) if $j == 0;
        }
        if $i+1 == $height {
           #say "bottom cell: adding edge below";
           add-edge($region, $i+1, $j, $i+1, $j+1);
        }
        if $j+1 == $width {
           #say "right cell: adding to right";
           add-edge($region, $i, $j+1, $i+1, $j+1);
        }
        
        for ($i,$j+1),($i+1,$j) -> ($ni, $nj) {
            if $ni < $height && $nj < $width {
                my $neighbor = @region[$ni;$nj];
                if $neighbor != $region {
                    my ($a, $b) = $i == $ni ?? ($i,$j+1) !! ($i+1,$j);;
                    add-edge($region, $a, $b, $i+1, $j+1);
                    add-edge($neighbor, $a, $b, $i+1, $j+1);
                }
            }
        }
    }
}
say [+] @area Z* @perimeter;
say [+] @area Z* @sides;

# set a plot's region number and recursively expand to the rest of the
# region
sub set-region($i, $j, $region) {
    @region[$i;$j] = $region;
    for ($i-1,$j),($i,$j-1),($i,$j+1),($i+1,$j) -> ($ni,$nj) {
        if defined(@map[$ni;$nj]) && !defined(@region[$ni;$nj]) &&
          @map[$ni;$nj] eq @map[$i;$j] {
             set-region($ni, $nj, $region);
       }
   }
}

#.say for @region;
#say '';
#
#for @sides.pairs { 
#    say "{.key}:{+.value}";
#}

# add an edge between vertices i0, j0 and i1, j1 (where vertex i,j is
# the upper left corner of cell i,j)
sub add-edge($region, $i0, $j0, $i1, $j1) {
    #say "into add-edge($region); currently: {@sides[$region].raku}";

    # we only find each edge onces, so any edge increases the perimeter
    @perimeter[$region]++;

    # look for an existing side going through i0,j0 in the right direction
    my $found = False;
    for @(@sides[$region]) -> $side {
        my ($a, $b, $c, $d) = @$side;
        #say "a=$a, b=$b, c=$c, d=$d";
        if $c == $i0 && $d == $j0 && sign($c - $a) == sign($i1 - $i0) &&
           sign($d - $b) == sign($j1 - $j0) {
            $side[2,3] = $i1, $j1;
            $found = True;
            #say "region $region: extended [$a,$b,$c,$d] to [{@$side.join(',')}]";
        }
    }
    if !$found {
        @sides[$region].push: [$i0, $j0, $i1, $j1];
        #say "region $region: added [$i0,$j0,$i1,$j1]";
    }
}
