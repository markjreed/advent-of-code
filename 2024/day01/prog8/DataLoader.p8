%import KiloFloat

DataLoader {
    sub load(uword filename, uword list1, uword list2) -> uword {
        ubyte[81] linebuffer 
        float f

        if not diskio.f_open(filename) {
           txt.print("no data file")
           txt.nl()
           sys.exit(1)
        }

        uword lines = 0
        ubyte bytes, status, i
        do {
            bytes, status = diskio.f_readline(linebuffer) 
            if bytes != 0 {
                i = 0
                f = 0
                while linebuffer[i] >= '0' and linebuffer[i] <= '9' {
                    f = f * 10 + (linebuffer[i] - '0' as float)
                    i += 1
                }
                KiloFloat.set_data_item(list1, lines, f)

                while linebuffer[i] == ' ' {
                    i += 1
                }

                f = 0
                while linebuffer[i] >= '0' and linebuffer[i] <= '9' {
                    f = f * 10 + (linebuffer[i] - '0' as float)
                    i += 1
                }
                KiloFloat.set_data_item(list2, lines, f)
                lines += 1
            }
        } until (status & 64) == 64
        diskio.f_close()
        KiloFloat.set_length(list1, lines)
        KiloFloat.set_length(list2, lines)
        return lines
    }
}
