#!/usr/bin/env raku
my @grid = lines()».comb;

my $root = ((@grid.kv.map: ->$i, @row { |@row.kv.map: -> $j, $sym { ($i + i*$j) => $sym } }).grep(
    -> (:$key, :$value) { $value eq 'S' })».key)[0];

my ($part1, $part2) »=» 0;
my %beams{Complex} = $root => 1;
while %beams {
    my %copy{Complex} = %beams;
    %beams = ();
    for %copy.keys -> $k {
        my :(:$re, :$im) := $k;
        my $next = $re + 1;
        if $next >= @grid {
            $part2 += %copy{$k};
            next;
        }
        if @grid[$next][$im] eq '.' {
            %beams{$next + i*$im} += %copy{$k};
        } elsif @grid[$next][$im] eq '^' {
            $part1++;
            if $im > 0 {
                %beams{$next + i*($im-1)} += %copy{$k};
            }
            if $im + 1 < @grid[$re] {
                %beams{$next + i*($im+1)} += %copy{$k};
            }
        } 
    }
}
say $part1;
say $part2;
