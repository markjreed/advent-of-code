# Run BASIC in VICE via `make PROG=filename`
data.cbm: ../data.txt
	tr $$'\n' $$'\r' <$< >$@

run: data.cbm $(PROG)
ifdef PROG
	x64sc -warp -ntsc -fs8 . -iecdevice8 -drive8type 1 +truedrive -keybuf "$$(tr A-Z a-z <$(PROG))"$$'\nrun\n'
else
	@echo >&2 "Need PROG=filename"
	@false
endif
