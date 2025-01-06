#!/usr/bin/env raku
unit sub MAIN($input);

role KeyPad {
    has $.height;
    has $.width;
    has @.buttons;
    has %.paths;
    has $.last is rw = 'A';
}

class GenericPad does KeyPad {
    our %directions = '^' => (-1,0), '>' => (0,1), 'v' => (1,0), '<' => (0,-1);

    submethod BUILD(:@buttons) {
        @!buttons = @buttons;
        $!height = +@buttons;
        $!width  = @buttons.map(+*).max;
        self.find-paths('A');
    }

    method coords($key) {
       ((^$!height) X (^$!width)).grep: -> ($i,$j) {
          defined(@!buttons[$i;$j]) && @!buttons[$i;$j] eq $key
       };
    }

    method find-paths($start-key) {
        die "Key '$start-key' not found" unless +(self.coords($start-key));
        %!paths = ();
        my $inf = 'X' x +(@!buttons.map(|*));
        my %edges;
        my $unvisited = SetHash.new;
        for @!buttons.kv -> $i, @row {
            for @row.kv -> $j, $key {
                next unless defined $key;
                $unvisited.set($key);
                %!paths{$key} = [ $inf ];
                for %directions.kv -> $dir, ($di, $dj) {
                    my ($ni, $nj) = ($i, $j) Z+ ($di, $dj);
                    if $ni >= 0 && $nj >= 0 && defined(my $nkey = @!buttons[$ni;$nj]) {
                        %edges{$key}{$nkey} = $dir;
                    }
                }
            }
        }
        %!paths{$start-key} = [ '' ];
        while +$unvisited {
            my $node = $unvisited.keys.min({%!paths{$_}.chars});
            $unvisited.unset($node);
            last if %!paths{$node} eqv [ $inf ];
            for %edges{$node}.kv -> $neighbor, $dir {
                my @alts = %!paths{$node}.map: * ~ $dir;
                if %!paths{$neighbor}:!exists || @alts[0].chars < %!paths{$neighbor}[0].chars {
                    %!paths{$neighbor} = @alts;
                } elsif @alts[0].chars == %!paths{$neighbor}[0].chars {
                    %!paths{$neighbor}.push(|@alts)
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

my @pads = NumPad.new;

#for ^3 {
#    @pads.push: DirPad.new;
#}

sub resolve($code, @pads) {
    say "into resolve('$code', @pads={@pads})";
    unless @pads {
        return $code;
    }
    my $result;
    for $code.comb -> $key {
        say "looking for $key in {@pads[0]}";
        say "paths: {@pads[0].paths{$key}}";
        my $path;
        for @(@pads[0].paths{$key}) -> $candidate {
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

