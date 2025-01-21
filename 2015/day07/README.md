# 2015 Day 6 Solution
The randomly-chosen language for today, carried forward from yesterday, was
Logo. 

To run: `ucblogo day7.logo - input.txt a b`.

(Since the sample input has no `a` or `b` wires, the problem statement can't
be applied to it. So if the program is run with just a filename, it simply
dumps out all the wire names and their final values. If it is run with a pair
of wire names, then it prints out the initial value of the first wire,
then sets the second wire to that value and re-evaluates the first one,
printing the new value.)

Along the way I also implemented it in a few other languages; the Raku solution
is the most straightforward since Raku has first-class closures and
default-mutable state.  Clojure has closures (it's in the name) so the only
adaptation required there was introducing atoms for mutable state. Tcl was good
practice for Logo as the delayed-evaluation values are just
lists to be evaluated by the `expr` command. The command-line interface is much the same
for these:

To run the Clojure solution: `lein exec day7.clj input.txt a b`

To run the Raku  solution:   `raku day7.raku input.txt a b`

To run the Tcl solution:     `tclsh day7.tcl input.txt a b`

|File|Description
|---|--------|
|[day7.logo](day7.logo)   | Solution |
|[sample.txt](sample.txt) | Sample input from the problem description |
|[input.txt](input.txt)   | My program input (encrypted) |
|[day7.clj](day7.clj)     | Clojure solution |
|[day7.raku](day7.raku)   | Raku solution |
|[day7.tcl](day7.tcl)     | Tcl solution |
