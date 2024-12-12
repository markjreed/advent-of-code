#!/usr/bin/env raku
unit sub MAIN($input);

my @map = $input.IO.lines».comb».Array;

my $height = +@map;
my $width = +@map[0];

my (@area, @perimeter);

my @region = (Array) xx @map;

my @plant-type;

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
           @plant-type.push($plant);
       }
       set-region($i, $j, $region);
    }
}

for @region.kv -> $i, @row {
    for @row.kv -> $j, $region {
        @perimeter[$region]++ if $i == 0;
        @perimeter[$region]++ if $j == 0;
        @area[$region]++;
        for ($i,$j+1),($i+1,$j) -> ($ni, $nj) {
            if $ni == $height || $nj == $width {
                @perimeter[$region]++;
            } else {
                my $neighbor = @region[$ni;$nj];
                if $neighbor != $region {
                    @perimeter[$region] += 1;
                    @perimeter[$neighbor] += 1;
                }
            }
        }
    }
}
say [+] @area Z* @perimeter;

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
