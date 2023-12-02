%zeropage basicsafe
%import diskio
%import floats
%import string
%import syslib
%import textio

main {
    str filename="input.seq"
    const uword nil = 0
    uword line
    ubyte[80] copy
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
    ubyte l
    str[] digits = [ "zero", "one", "two",   "three", "four",
                     "five", "six", "seven", "eight", "nine" ]
    ubyte digit
    ubyte d

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

    sub ti() -> float {
        ubyte a
        ubyte x
        ubyte y
        %asm{{
            jsr cbm.RDTIM
            sta p8_a
            stx p8_x
            sty p8_y
        }}
        return (a as float) + 256 * (x as float + 256 * (y as float))
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
               digit = line[i]
               if line[i] >= '0' and line[i] <= '9' {
                   first = line[i] - '0' as byte
                   break;
               }
               for d in 0 to 9 {
                   string.slice(line, i, string.length(digits[d]), copy)
                   if string.compare(digits[d], copy) == 0 {
                       first = d as byte
                       break;
                   }
               }
               if first >= 0 
                   break;
               i = i + 1
           }
           last = -1
           i = string.length(line) - 1
           while 1 {
               if line[i] >= '0' and line[i] <= '9' {
                   last = line[i] - '0' as byte
                   break
               }
               for d in 0 to 9 {
                   l = string.length(digits[d])
                   if i-l+1 < i {
                       string.slice(line, i-l+1, l, copy)
                       if string.compare(digits[d], copy) == 0 {
                           last = d as byte
                           break;
                       }
                   }
               }
               if last >= 0 break
               i = i - 1
               if i == 255 break
           }
           total = total + (first as ubyte)*10 + (last as ubyte)
           line = read_line()
        }
        txt.print_uw(total)
        txt.nl()
        floats.print_f(ti())
        txt.nl()
    }
}
