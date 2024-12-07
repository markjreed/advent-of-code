unit module Day07;

sub try-to-make($goal, @components, $with-concat) is export {
    # say "try-to-make($goal, {@components.raku}, $with-concat)";
    if @components.Array eqv [$goal] {
        # say '   True: components = [goal]';
        return True;
    }

    if @components < 2 {
        # say '   False: not enough components.';
        return False;
    }

    my $last = @components[*-1];
    if $last > $goal {
        # say '   False: remaining component too big.';
        return False;
    }

    if try-to-make($goal - $last, @components[0..*-2], $with-concat) {
        # say '   True: recursion with +';
        return True;
    }

    # try * 
    if $goal %% $last && try-to-make($goal div $last, @components[0..*-2], $with-concat) {
        # say '   True: recursion with *';
        return True;
    }

    if $with-concat && $goal ~~ / ^( .* ) $last $ / && try-to-make(+$0, @components[0..*-2], $with-concat) {
        # say '   True: recursion with ||';
        return True;
    }
    return False;
}
