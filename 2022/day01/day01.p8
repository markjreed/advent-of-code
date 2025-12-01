%import diskio
%import floats
%import strings
%import syslib
%import textio
%zeropage basicsafe

lines {
; abstraction around diskio.f_readline; returns pointer to line read,
; nil on EOF
  const uword nil = $0000
  ubyte[256] buffer
  bool eof = false
  ubyte length, status

  sub readline() -> ^^ubyte {
    if eof {
      eof = false
      return nil
    }
    length, status = diskio.f_readline(&buffer)
    if status & 64 != 0 {
       eof = true
    } else if status != 0 {
      ; something else went wrong; caller
      ; wll have to call READST to find out what
      return nil
    }
    return &buffer
  }
}

main {
  sub start() {
    bool ok
    bool done
    ubyte[80] filename
    uword line
    ubyte line_len
    ubyte i
    float cur_snack
    float cur_total
    float top_total
    float[3] maxima = [0, 0, 0]
    uword line_count = 0

    repeat {
      ok = false
      while not ok {
        txt.print("filename:")
        void txt.input_chars(&filename)
        txt.nl()
        if strings.length(filename) < 2 {
          txt.print("never mind.")
          sys.exit(0)
        }
        ok = diskio.f_open(filename)
      }
      txt.chrout(0)

      cur_total = 0.0
      for i in 0 to 2 {
        maxima[i] = 0
      }
      done = false
      line_count = 0

      while not done {
        txt.chrout(0)
        line = lines.readline()
        i = 0
        if line == lines.nil {
          done = true
        } else {
          line_count += 1
          ; txt.print("read line #")
          ; txt.print_uw(line_count)
          txt.nl()
          cur_snack = 0
          while line[i] != 0 {
            if line[i] >= '0' and line[i] <= '9' {
              cur_snack = cur_snack * 10 + (line[i] - '0') as float
            }
            i=i+1
          }
        }
        if i==0 {
          if cur_total > maxima[2] {
            maxima[2] = cur_total
            if cur_total > maxima[1] {
              maxima[2] = maxima[1]
              maxima[1] = cur_total
              if cur_total > maxima[0] {
                maxima[1] = maxima[0]
                maxima[0] = cur_total
              }
            }
          }
          cur_total = 0
        } else {
          cur_total += cur_snack
        }
      }
      diskio.f_close()
      txt.print("read ")
      txt.print_uw(line_count-1)
      txt.print(" lines")
      txt.nl()
      txt.print("highest total:")
      txt.print_f(maxima[0])
      txt.nl()
      top_total = maxima[0]
      for i in 1 to 2 {
        top_total += maxima[i]
      }
      txt.print("top 3 total:")
      txt.print_f(top_total)
      txt.nl()
      txt.nl()
    }
  }
}
