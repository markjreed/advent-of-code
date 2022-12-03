%import diskio
%import floats
%import string
%import syslib
%import textio
%zeropage basicsafe

main {
  const uword nil = $0000
  ubyte[256] buffer
  bool eof = false
  ubyte buf_size = 0
  ubyte num_lines = 0
  ubyte cur_line = 0
  ubyte last_line = 0
  ubyte[256] lines
  ubyte last_line_len

  sub read_line() -> uword {
    ubyte i

    if eof  {
      eof = false
      buf_size = 0
      num_lines = 0
      cur_line = 0
      last_line = 0
      return nil
    }

    if lines[cur_line] == last_line {
      last_line_len = buf_size - last_line
      for i in 0 to last_line_len-1 {
        buffer[i] = buffer[i+last_line]
      }
      buf_size = diskio.f_read(&buffer+last_line_len, 255-last_line_len) as ubyte
      if buf_size == 0 {
        eof = true
      }
      buf_size += last_line_len
      lines[0] = 0
      num_lines = 1
      for i in 0 to buf_size {
        if buffer[i] == 10 {
          buffer[i] = 0
          last_line = i+1
          lines[num_lines] = i+1
          num_lines = num_lines + 1
        }
      }
      buffer[buf_size]=0
      cur_line = 0
    }
    cur_line = cur_line + 1
    return &buffer + lines[cur_line-1]
  }

  sub start() {
    bool ok
    bool done
    ubyte[80] filename
    uword line
    ubyte line_len
    ubyte i
    float cur_snack;
    float cur_total;
    float top_total;
    float[3] max = [0, 0, 0]
    uword line_count = 0

    repeat {
      ok = false
      while not ok {
        txt.print("filename:")
        void txt.input_chars(&filename)
        txt.nl()
        if string.length(filename) < 2 {
          txt.print("never mind.")
          sys.exit(0)
        }
        ok = diskio.f_open(8, filename)
      }

      cur_total = 0
      for i in 0 to 2 {
        max[i] = 0
      }
      done = false
      line_count = 0

      while not done {
        line = read_line()
        i = 0
        if line == nil {
          done = true
        } else {
          line_count += 1
          cur_snack = 0
          while line[i] != 0 {
            if line[i] >= '0' and line[i] <= '9' {
              cur_snack = cur_snack * 10 + (line[i] - '0') as float
            }
            i=i+1
          }
        }
        if i==0 {
          if cur_total > max[2] {
            max[2] = cur_total
            if cur_total > max[1] {
              max[2] = max[1]
              max[1] = cur_total
              if cur_total > max[0] {
                max[1] = max[0]
                max[0] = cur_total
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
      floats.print_f(max[0])
      txt.nl()
      top_total = max[0]
      for i in 1 to 2 {
        top_total += max[i]
      }
      txt.print("top 3 total:")
      floats.print_f(top_total)
      txt.nl()
      txt.nl()
    }
  }
}
