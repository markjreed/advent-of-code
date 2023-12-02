%zeropage basicsafe
%import diskio
%import floats
%import textio
%import syslib

main {
    str filename="input.seq"
    const uword nil = 0
    uword line
    ubyte[255] buffer
    ubyte buflen
    ubyte bufidx
    ubyte end
    ubyte eol
    bool eof
    uword total
    ubyte i 
    byte first
    byte last

    sub read_line() -> uword {
        uword lineptr

        if buflen == 0 or bufidx >= buflen or eol == 255 {
            if eof return nil

            if eol == 255 {
                if bufidx == 0 {
                    txt.print("Line too long!\n")
                    sys.exit(1)
                }
                end = buflen - bufidx
                for i in 0 to end-1 {
                    buffer[i] = buffer[bufidx + i]
                }
                buflen = end + (diskio.f_read(&buffer + end, 254 - end) as ubyte)
            } else {
                buflen = diskio.f_read(buffer, 254) as ubyte
            }
            eof = (buflen < 254) or (cbm.READST() and 64)
            bufidx = 0
            eol = 255
            for i in 0 to buflen - 1 {
                if buffer[i] == '\r' {
                    eol = i
                    break
                }
            }
        }

        lineptr = &buffer + bufidx
        buffer[eol] = 0
        bufidx = eol + 1
        if bufidx < eol {
          buflen = 0
        }
        eol = 255
        for i in bufidx to buflen - 1 {
            if buffer[i] == '\r' {
                eol = i
                break
            }
        }
        return lineptr
    }

    sub start() {
        if not diskio.f_open(filename) {
          txt.print(diskio.status())
          sys.exit(1)
        }
        total = 0
        line = read_line()
        while line != nil {
           i = 0
           first = -1
           while line[i] {
               if line[i] >= '0' and line[i] <= '9' {
                   last = line[i] as byte
                   if first < 0 first = line[i] as byte
               }
               i = i + 1
           }
           total = total + (first as ubyte - '0')*10 + (last as ubyte - '0')
           line = read_line()
        }
        txt.print_uw(total)
        txt.nl()
    }
}
