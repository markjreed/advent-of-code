%import diskio
%import string
%import syslib
%import textio
%zeropage basicsafe

lines {
; abstraction around diskio.f_readline; returns pointer to line read,
; nil on EOF
  const uword nil = $0000
  ubyte[256] buffer
  bool eof = false
  ubyte status

  sub readline() -> uword {
    if eof {
      eof = false
      return nil
    }
    diskio.f_readline(&buffer)
    status = c64.READST() 
    if status & 64 {
       eof = true
    } else if status {
      ; something else went wrong; caller
      ; wll have to call READST to find out what
      return nil
    }
    return &buffer;
  }
}

main {

  const ubyte disk_drive = 8

  sub part1(ubyte elf, ubyte human) -> ubyte {
    return (human - elf + 4) % 3 * 3 + human + 1
  }

  sub part2(ubyte elf, ubyte human) -> ubyte {
    return 3 * human + (elf + human + 2) % 3 + 1
  }

  sub start() {
    bool ok
    bool done
    ubyte[80] filename
    uword line
    uword line_count = 0
    uword part1_total
    uword part2_total
    ubyte human
    ubyte elf

    repeat {
      ok = false
      while not ok {
        txt.nl()
        txt.print("filename:")
        void txt.input_chars(&filename)
        txt.nl()
        if string.length(filename) < 2 {
          txt.print("never mind.")
          txt.nl()
          sys.exit(0)
        }
        ok = diskio.f_open(disk_drive, filename)
        if not ok {
          txt.print("couldn't open file.")
          txt.nl()
        }
      }

      part1_total = 0
      part2_total = 0
      done = false
      line_count = 0

      while not done {
        line = lines.readline()
        if line == lines.nil {
          done = true
        } else {
          line_count += 1
          if line[0] >= 'a' and line[0] <= 'c' {
            elf = line[0] - 'a'
            human = line[2] - 'x'
            part1_total += part1(elf, human)
            part2_total += part2(elf, human)
          }
        }
      }
      diskio.f_close()
      txt.print("read ")
      txt.print_uw(line_count-1)
      txt.print(" lines")
      txt.nl()
      txt.print("part1 total:")
      txt.print_uw(part1_total)
      txt.nl()
      txt.print("part2 total:")
      txt.print_uw(part2_total)
      txt.nl()
      txt.nl()
    }
  }
}
