ifeq ($(TARGET),)
    TARGET = cx16
endif

%: %.prg
ifeq ($(TARGET),cx16)
	x16emu -prg "$<" -fsroot .. -startin .. -run
else ifeq ($(TARGET),c64)
	x64sc -virtualdev8 -iecdevice8 -device8 1 -fs8 .. +drive8truedrive -keybuf $$'load"prog8/$<",8\nrun\n'
endif

day05.prg: day05.p8 PageSet.p8 PageSet_def.p8 Rules.p8 Rules_def.p8

%.prg: %.p8
	prog8c -target $(TARGET) "$<"

%_def.p8: %.def ~/bin/mkp8class
	mkp8class $* $<

%.p8: %.def ~/bin/mkp8class
	mkp8class $* $<
