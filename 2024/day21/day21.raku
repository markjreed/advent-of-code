#!/usr/bin/env raku
unit sub MAIN($input);

role KeyPad {
    has $.height;
    has $.width;
    has @.buttons;
    has %.paths;
    has $.position is rw = 'A';
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
        my $inf = 'X' x +@keys;
        for @!buttons.kv -> $i, @row {
            for @row.kv -> $j, $key {
                next unless defined $key;
                %!paths{$key}{$key} = SetHash.new('');
                for %directions.kv -> $dir, ($di, $dj) {
                    my ($ni, $nj) = ($i, $j) Z+ ($di, $dj);
                    if $ni >= 0 && $nj >= 0 && 
                      defined(my $nkey = @!buttons[$ni;$nj]) {
                        %!paths{$key}{$nkey} = SetHash.new($dir);
                    }
                }
            }
        }
        for @keys -> $a {
            for @keys -> $b {
                if %!paths{$a}{$b}:!exists {
                    %!paths{$a}{$b} = SetHash.new($inf);
                }
            }
        }
        for @keys -> $a {
            for @keys -> $b {
                for @keys -> $c {
                    my $old = %!paths{$a}{$c}.keys[0].chars;
                    my $ab = %!paths{$a}{$b}.keys[0];
                    my $bc = %!paths{$b}{$c}.keys[0];
                    my $alt = ($ab ~ $bc).chars;
                    if $alt < $old {
                        %!paths{$a}{$c} = SetHash.new(
                            %!paths{$a}{$b}.keys X~ %!paths{$b}{$c}.keys
                        );
                    } elsif $alt == $old {
                        %!paths{$a}{$c}.set: (
                            %!paths{$a}{$b}.keys X~ %!paths{$b}{$c}.keys
                        );
                    }
                }
            }
        }
    }
}

class NumPad does KeyPad {
    has GenericPad $!pad handles «paths»;
    submethod BUILD {
       $!pad = GenericPad.new(buttons => [[7,8,9],[4,5,6],[1,2,3],[Any,0,'A']]);
    }
}

class DirPad does KeyPad {
    has GenericPad $!pad handles «paths»;
    submethod BUILD {
       $!pad = GenericPad.new(buttons => [[Any, '^', 'A'],['<','v','>']]);
    }
}

# given a code to press on the first pad in the list, translate it into
# button presses for the next one down, recursively
sub resolve($code, @pads) {
    say "into resolve('$code', @pads={@pads})";
    unless @pads {
        return $code;
    }
    my $result;
    my ($pad, @rest) = @pads;
    my $pos = $pad.position;
    for $code.comb -> $key {
        my $path;
        for @($pad.paths{$pos}{$key}) -> $candidate {
            my $resolved  = resolve($candidate, @pads[1..*]) ~ 'A';
            if !defined($path) || $resolved.chars < $path.chars {
                $path = $resolved;
            }
        }
        $result ~= $path;
    }
    return $result;
}

my $code = '029A';
say resolve($code, @pads);

