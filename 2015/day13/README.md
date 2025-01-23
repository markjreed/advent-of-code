# 2015 Day 13 Solution
The randomly-chosen language for today is BASIC. I opted to use the BASIC built
into the "modern retro" Commander X16 computer, which has many improvements, but
at its core is the same BASIC ROM that shipped on the Commodore 64 in 1982.

As a concession to modernity I'm using Stefan Jakobsson's excellent [BASLOAD
preprocessor](https://github.com/stefan-b-jakobsson/basload-rom) so that I can
use labels instead of line numbers, and variable names with more than two
distinct characters. 

The easiest way to run it is to paste the [pretranslated BASIC](day13.bas) into
the [online Commander X16
emulator](https://www.commanderx16.com/webemu/x16emu.html). If you have a local X16 emulator, you can just run it from a directory containing the [original source](day13.bsl) and run `BASLOAD "day13.bsl"` to do the translation over again. 

Either way, be prepared to wait a while. The X16 is about 8x faster than the
C64, but that's still not fast. The program takes most of an hour to run
at native speed; in local emulation you can use the `-warp` option to speed
it up by at least a factor of 2.

|File|Description
|---|--------|
|[day13.bsp](day13.bsl)     | Solution in BASLOAD syntax                |
|[day13.bas](day13.bas)     | Transpiled solution in native X16 BASIC   |
|[sample.txt](sample.txt)   | Sample input from the problem description |
|[input.txt](input.txt)     | My program input (encrypted)              |
