# 2015 Day 13 Solution
The randomly-chosen language for today is BASIC. There are many varieites of
BASIC; I opted to use the BASIC built into the "modern retro" [Commander
X16](https://commanderx16.com) computer. X16 BASIC has many improvements, but
at its core is the same BASIC ROM that shipped on the Commodore 64 in 1982.

As a concession to modernity I'm using Stefan Jakobsson's excellent [BASLOAD
preprocessor](https://github.com/stefan-b-jakobsson/basload-rom) so that I can
use labels instead of line numbers, and variable names with more than two
distinct characters. But it just transpiles into good old-fashioned
line-numberful BASIC with two-char variable names.

I've posted the program to the [Commander X16 Forums](), which allows me to
include this [Try It Now]() link to run it in the online emulator. 

It defaults to running on the sample input. If you run it on the full input
file instead, be prepared to wait a while; the X16 is about 8x faster than the
C64, but that's still not fast. On my input the program takes most of an hour
to run at native speed. If you have a local install of the emulator you can use
the `-warp` option to run it as fast as your hardware can manage the emulation,
but even on my M3 MacBook Pro that's only about 2x.

|File|Description
|---|--------|
|[day13.bsl](day13.bsl)     | Solution                                  |
|[day13.bas](day13.bas)     | Plain BASIC loader 
|[sample.txt](sample.txt)   | Sample input from the problem description |
|[input.txt](input.txt)     | My program input (encrypted)              |
