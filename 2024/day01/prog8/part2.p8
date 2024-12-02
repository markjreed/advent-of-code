%zeropage basicsafe
%import KiloFloat
%import diskio
%import syslib
%import textio

main {
    sub start() {
        uword list1 = memory("list1", KiloFloat.SIZE, 1)
        uword list2 = memory("list2", KiloFloat.SIZE, 1)
        ubyte[81] linebuffer 
        float f, sum

        if not diskio.f_open("data.txt") {
           txt.print("no data file")
           txt.nl()
           sys.exit(1)
        }
        uword line, lines 
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

        sum = 0
        for line in 0 to lines - 1 {
            f = KiloFloat.get_data_item(list1, line)
            sum = sum + f * (KiloFloat.count(list2, f) as float)
        }
        txt.print_f(sum)
        txt.nl()
    }
}
