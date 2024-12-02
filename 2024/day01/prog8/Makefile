%: %.prg
	x16emu -prg "$<" -fsroot .. -startin .. -run

%.prg: %.p8
	prog8c -target cx16 "$<"

part1.prg: part1.p8 DataLoader.p8 KiloFloat.p8 KiloFloat_def.p8 

part2.prg: part2.p8 DataLoader.p8 KiloFloat.p8 KiloFloat_def.p8 

%_def.p8: %.def ~/bin/mkp8class
	mkp8class $* $<
