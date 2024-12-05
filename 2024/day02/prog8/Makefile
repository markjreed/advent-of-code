ifeq ($(TARGET),)
    TARGET = cx16
endif

%: %.prg
ifeq ($(TARGET),cx16)
	x16emu -prg "$<" -fsroot .. -startin .. -run
else ifeq ($(TARGET),c64)
	x64sc -virtualdev8 -iecdevice8 -device8 1 -fs8 .. -keybuf $$'load"prog8/$<",8\nrun\n'
endif

%.prg: %.p8
	prog8c -target $(TARGET) "$<"

part1.prg: part1.p8 DataLoader.p8 ReportList.p8 ReportList_def.p8 

part2.prg: part2.p8 DataLoader.p8 ReportList.p8 ReportList_def.p8 

%_def.p8: %.def ~/bin/mkp8class
	mkp8class $* $<
