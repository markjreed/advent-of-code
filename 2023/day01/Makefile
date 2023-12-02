all: sample1.seq sample2.seq input.seq

%.seq: %.txt
	tr 'a-z\n' 'A-Z\r' <$< >$@
