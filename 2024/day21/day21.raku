#!/usr/bin/env raku
unit sub MAIN($input, :$verbose = False);

role KeyPad {
    has $.height;
    has $.width;
    has @.buttons;
    has %.paths;
}

sub compare-paths($path1, $path2) {
    return Less  if $path1.chars < $path2.chars;
    return More if $path1.chars > $path2.chars;
    return Less  if $path1 ~~ /^ <[v^]>+ <[><]>+ $/;
    return More if $path2 ~~ /^ <[v^]>+ <[><]>+ $/;
    return Less if $path1 ~~ /^ <[><]>+ <[v^]>+ $/;
    return More if $path2 ~~ /^ <[><]>+ <[v^]>+ $/;
    return Same;
}
class GenericPad does KeyPad {
    our %directions = '^' => (-1,0), '>' => (0,1), 'v' => (1,0), '<' => (0,-1);

    submethod BUILD(:@buttons) {
        @!buttons = @buttons;
        $!height = +@buttons;
        $!width  = @buttons.map(+*).max;
        self.find-paths;
    }

    method coords($key) {
       ((^$!height) X (^$!width)).grep: -> ($i,$j) {
          defined(@!buttons[$i;$j]) && @!buttons[$i;$j] eq $key
       };
    }

    # find the shortest paths between every pair of buttons
    # %!paths{a}{b} = set of direction strings, all the same minimal length,
    # that will take the pointer from a to b
    method find-paths() {
        %!paths = ();
        my @keys = @!buttons.map(|*).grep: { defined($_) };
        my $inf = 'X' x (+@keys * +@keys);
        for @!buttons.kv -> $i, @row {
            for @row.kv -> $j, $key {
                next unless defined $key;
                %!paths{$key}{$key} = SetHash.new: '';
                for %directions.kv -> $dir, ($di, $dj) {
                    my ($ni, $nj) = ($i, $j) Z+ ($di, $dj);
                    if $ni >= 0 && $nj >= 0 && 
                      defined(my $nkey = @!buttons[$ni;$nj]) {
                        %!paths{$key}{$nkey} = SetHash.new: $dir;
                    }
                }
            }
        }

        for @keys -> $b {
            for @keys -> $a {
                for @keys -> $c {
                    if (%!paths{$a}{$b}:exists) && %!paths{$a}{$b} && (%!paths{$b}{$c}:exists) && %!paths{$b}{$c} {
                        my @alt = (%!paths{$a}{$b}.keys X~ %!paths{$b}{$c}.keys).sort({$^a.chars <=> $^b.chars});
                        if %!paths{$a}{$c}:!exists || @alt[0].chars < %!paths{$a}{$c}.keys[0].chars {
                            %!paths{$a}{$c} = SetHash.new(@alt.grep({.chars == @alt[0].chars}));
                        } elsif @alt[0].chars == %!paths{$a}{$c}.keys[0].chars {
                            %!paths{$a}{$c}.set(@alt.grep({.chars == @alt[0].chars}));
                        }
                    }
                }
            }
        }
        for @keys -> $b {
            for @keys -> $a {
                for @keys -> $c {
                    if (%!paths{$a}{$b}:exists) && %!paths{$a}{$b} && (%!paths{$b}{$c}:exists) && %!paths{$b}{$c} {
                        my @alt = (%!paths{$a}{$b}.keys X~ %!paths{$b}{$c}.keys).sort({$^a.chars <=> $^b.chars});
                        if %!paths{$a}{$c}:!exists || @alt[0].chars < %!paths{$a}{$c}.keys[0].chars {
                            %!paths{$a}{$c} = SetHash.new(@alt.grep({.chars == @alt[0].chars}));
                        } elsif @alt[0].chars == %!paths{$a}{$c}.keys[0].chars {
                            %!paths{$a}{$c}.set(@alt.grep({.chars == @alt[0].chars}));
                        }
                    }
                }
            }
        }
    }
}

class NumPad does KeyPad {
    has GenericPad $!pad handles «paths buttons»;
    submethod BUILD {
       $!pad = GenericPad.new(buttons => [[7,8,9],[4,5,6],[1,2,3],[Any,0,'A']]);
    }
}

class DirPad does KeyPad {
    has GenericPad $!pad handles «paths buttons»;
    submethod BUILD {
       $!pad = GenericPad.new(buttons => [[Any, '^', 'A'],['<','v','>']]);
    }
}

sub resolve($sequence, @pads is copy, @positions is copy) {
    return $sequence unless +@pads;

    my $pad = @pads.shift;
    my $pos = @positions.shift;

    my $result = '';
    for $sequence.comb -> $key {
        my @candidates = ();
        for $pad.paths{$pos}{$key}.keys -> $start {
            @candidates.push:  resolve($start ~ 'A', @pads, @positions);
        }
        $result ~= @candidates.sort(&compare-paths)[0];
        $pos = $key;
    }
    return $result;
}

my @pads = NumPad.new, DirPad.new, DirPad.new;
my @positions = 'A' xx @pads;
my $part1 = 0;
for $input.IO.lines -> $code {
    my $num = +($code ~~ / <[1..9]><[0..9]>* /);
    my $sequence = resolve($code, @pads, @positions);
    my $len = $sequence.chars;
    my $complexity = $num * $sequence.chars;
    say "$code: $sequence (complexity: $num x $len = $complexity)" if $verbose;
    $part1 += $complexity;
}
say $part1;

