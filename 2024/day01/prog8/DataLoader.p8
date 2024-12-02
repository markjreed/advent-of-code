DataLoader {
    sub load(uword filename, uword list1, uword list2) -> uword {
        ubyte[81] linebuffer 
        float f

        if not diskio.f_open(filename) {
           txt.print("no data file")
           txt.nl()
           sys.exit(1)
        }

        uword lines 
        ubyte bytes, status, i
        do {
            bytes, status = diskio.f_readline(linebuffer) 
            f = 0
            for i in 0 to 4 {
                f = f * 10 + (linebuffer[i] - '0' as float)
            }
            KiloFloat.set_data_item(list1, lines, f)
            f = 0
            for i in 8 to 12 {
                f = f * 10 + (linebuffer[i] - '0' as float)
            }
            KiloFloat.set_data_item(list2, lines, f)
            lines += 1
        } until (status & 64) == 64
        diskio.f_close()
        return lines
    }
}
