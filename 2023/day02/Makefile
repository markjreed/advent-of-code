all: sample.seq input.seq

%.seq: %.txt
	tr 'a-z\n' 'A-Z\r' <$< >$@
