# 2015 Day 10 Solution
The randomly-chosen language for today is Pascal.

To run: `fpc day10.p && ./day10 input.txt`.

In which I learn that even when compiled for a 64-bit architecture, FreePascal's `int` type is only 16 bits wide;
had to use `LongInt`s for this one.

|File|Description
|---|--------|
|[day10.p](day10.p)     | Solution |
|[sample.txt](sample.txt) | Sample input from the problem description |
|[input.txt](input.txt)   | My program input (encrypted) |
