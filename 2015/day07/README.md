# 2015 Day 6 Solution
The randomly-chosen language for today, carried forward from yesterday, was
Logo. 

To run: `ucblogo day7.logo - input.txt a`.

Along the way I also implemented it in a few other languages; the Raku solution
is the most straightforward since Raku has first-class closures and
default-mutable state.  Clojure has closures (it's in the name) so the only
adaptation required there was introducing atoms for mutable state. Tcl was good
practice for Logo as the delayed-evaluation values are just
lists to be evaluated by the `expr` command.

|File|Description
|---|--------|
|[day7.logo](day7.logo) | Solution |
|[sample.txt](sample.txt) | Sample input from the problem description |
|[input.txt](input.txt) | My program input (encrypted) |

