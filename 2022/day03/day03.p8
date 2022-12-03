; %import byteset ; included inline below so this file is self-contained
%import diskio
%import floats
%import string
%import syslib
%import textio
%import unixfile
%zeropage basicsafe

byteset {
  const uword nil = $0000
  const uword set_size = 32
  const uword node_size = set_size + 2
  const uword mem_top = $b000
  uword next_new = $a000
  uword free_head = nil

  sub new() -> uword {
    uword new_set
    if free_head != nil {
      new_set = free_head + 2
      free_head = peekw(free_head)
    } else {
      if next_new + node_size > mem_top
        return nil
      new_set = next_new
      next_new += node_size
    }
    empty(new_set)
    return new_set
  }

  sub free(uword old_set) {
     pokew(old_set, free_head)
     free_head = old_set
  }

  sub set(uword this, ubyte value) {
    ubyte index = value >> 3
    ubyte bit = 1 << (value & $07)
    @(this+index) |= bit
  }

  sub is_set(uword this, ubyte value) -> bool {
    ubyte index = value >> 3
    ubyte bit = 1 << (value & $07)
    return 0 != (@(this+index) & bit)
  }

  sub unset(uword this, ubyte value) {
    ubyte index = value >> 3
    ubyte bit = ~(1 << (value & $07))
    @(this+index) &= bit
  }

  sub is_empty(uword this) -> bool {
    ubyte i
    for i in 0 to set_size-1 {
      if @(this + i) != 0 
        return false
    }
    return true
  }

  sub empty(uword this) {
    ubyte i
    for i in 0 to set_size-1 {
      @(this + i) = 0 
    }
  }

  ; return the number of items in the set
  sub count(uword this) -> ubyte {
    ubyte i
    ubyte total = 0
    for i in 0 to 255 {
      if is_set(this, i) 
        total += 1
    }
    return total
  }

  ; return the intersection of two sets in the provided result set
  sub intersect(uword left, uword right, uword result) {
    ubyte i
    for i in 0 to set_size-1 {
      @(result + i) = @(left + i) & @(right + i)
    }
  }

  ; return the union of two sets in the provided result set
  sub union(uword left, uword right, uword result) {
    ubyte i
    for i in 0 to set_size-1 {
      @(result + i) = @(left + i) | @(right + i)
    }
  }
}
main {
  const ubyte disk_drive = 8
  uword left
  uword right
  uword result
  uword[3] sets

  sub get_priority(ubyte item) -> ubyte {
    ubyte priority = item & $1f
    if item < 96
      priority += 26
    return priority
  }

  sub intersect2(str line) -> ubyte {
    ubyte i
    ubyte half = string.length(line) / 2
    ubyte retval

    byteset.empty(left)
    byteset.empty(right)
    for i in 0 to half-1 {
      byteset.set(left, line[i])
      byteset.set(right, line[half+i])
    }
    byteset.intersect(left, right, result)
    for i in 0 to 255 {
      if byteset.is_set(result, i) {
        retval = i
        break
      }
    }
    return retval
  }

  sub line2set(str line, uword set) {
    ubyte i
    bool first = true
    byteset.empty(set)
    for i in 0 to string.length(line)-1 {
      byteset.set(set, line[i])
    }
  }

  sub intersect3(uword set1, uword set2, uword set3) -> ubyte {
    ubyte i
    byteset.intersect(set1, set2, result)
    byteset.intersect(result, set3, set1)
    for i in 0 to 255 {
      if byteset.is_set(set1, i) {
        return i
      }
    }
  }

  sub start() {
    bool ok
    bool done
    ubyte[80] filename
    uword line
    uword line_count = 0
    float part1_total
    float part2_total
    ubyte pos
    ubyte i
    uword priority
    float fpriority

    left = byteset.new()
    right = byteset.new()
    result = byteset.new()

    for i in 0 to 2 {
      sets[i] = byteset.new()
    }

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
        } else if string.length(line)>0 {
          pos = (line_count % 3) as ubyte
          line_count += 1
          priority = get_priority(intersect2(line)) as uword
          fpriority = priority as float
          part1_total += fpriority
          line2set(line, sets[pos])
          if pos == 2 {
            priority=get_priority(intersect3(sets[0],sets[1],sets[2])) as uword
            fpriority = priority as float
            part2_total += fpriority
          }
        }
      }
      diskio.f_close()
      txt.print("read ")
      txt.print_uw(line_count)
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
