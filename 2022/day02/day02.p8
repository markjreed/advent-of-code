%import diskio
%import floats
%import string
%import syslib
%import textio
%import unixfile
%zeropage basicsafe

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
    ubyte bscore
    float fscore
    float part1_total
    float part2_total
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
        line = unixfile.read_line()
        if line == unixfile.nil {
          done = true
        } else {
          line_count += 1
          if line[0] >= 'a' and line[0] <= 'c' {
            elf = line[0] - 'a'
            human = line[2] - 'x'
            bscore = part1(elf, human)
            fscore = bscore as uword as float
            part1_total += fscore
            fscore = part2(elf, human) as uword as float
            part2_total += fscore
          }
        }
      }
      diskio.f_close()
      txt.print("read ")
      txt.print_uw(line_count-1)
      txt.print(" lines")
      txt.nl()
      txt.print("part1 total:")
      floats.print_f(part1_total)
      txt.nl()
      txt.print("part2 total:")
      floats.print_f(part2_total)
      txt.nl()
      txt.nl()
    }
  }
}
