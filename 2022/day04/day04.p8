;;======================================================================
;; Solve Advent of Code 2022 Day 4. https://adventofcode.com/2022/day/4
;;----------------------------------------------------------------------
%import diskio
%import string
%import syslib
%import textio
;%import range ; inlined below
%zeropage basicsafe

range {
; implements a simple signed byte range. The arguments are Pythonic:
; start, exclusive end, increment value, e.g. range.new(1,10,1) contains
; the values 1,2,3,4,5,6,7,8,9.

; used routines:
;    rng = range.new(from, to, increment)  ; constructor (used indirectly)
;    rng = range.seq(from, to)             ; useful for the common case of increment=1
;    range.free(rng)                       ; free memory used by range
;    range.contains(rng1, rng2)            ; returns true if the first range completely contains the second
;    range.overlaps(rng1, rng2)            ; returns true if the two ranges overlap
;
; unused routines found in the full lib:
;    rng = range.iota(count)               ; shortcut for new(0,count,1) or seq(0,count)
;    range.is_empty(rng)                   ; true if the range is empty
;    range.start(rng)                      ; reset iterator
;    range.done(rng)                       ; true if all elements have been returned
;    range.next(rng)                       ; returns the next value in the range

  const uword nil = $0000
  ; four 1-byte fields: start, end, increment, curr
  const uword o_start = 0
  const uword o_end   = 1
  const uword o_incr  = 2
  const uword o_curr  = 3
  const uword range_size = 4

  ; add a next pointer for free list
  const uword node_size = range_size + 2

  const uword mem_top = $b000
  uword next_new = $a000
  uword free_head = nil

  sub new(byte start, byte end, byte increment) -> uword {
    uword new_range
    if free_head != nil {
      new_range = free_head + 2
      free_head = peekw(free_head)
    } else {
      if next_new + node_size > mem_top
        return nil
      new_range = next_new
      next_new += node_size
    }
    @(new_range+o_start) = start as ubyte
    @(new_range+o_end)   = end as ubyte
    @(new_range+o_incr)  = increment as ubyte
    @(new_range+o_curr)  = start as ubyte
    return new_range
  }
 
  sub seq(byte start, byte end) -> uword {
    return new(start, end, 1)
  }

  sub free(uword old_range) {
    pokew(old_range, free_head)
    free_head = old_range
  }

  sub contains(uword rng1, uword rng2) -> bool {
    byte start1 = @(rng1+o_start) as byte
    byte start2 = @(rng2+o_start) as byte
    byte end1  =  @(rng1+o_end) as byte
    byte end2  =  @(rng2+o_end) as byte

    return start1 <= start2 and end1 >= end2
  }

  sub overlaps(uword rng1, uword rng2) -> bool {
    byte start1 = @(rng1+o_start) as byte
    byte start2 = @(rng2+o_start) as byte
    byte end1  =  @(rng1+o_end) as byte
    byte end2  =  @(rng2+o_end) as byte
    byte temp

    ; sort everything around
    if start1 > start2 {
      temp = start1
      start1 = start2
      start2 = temp
      temp = end1
      end1 = end2
      end2 = temp
    }
   return start2 < end1
  }
}

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
    void diskio.f_readline(&buffer)
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

;; main entrypoint: solve AoC 2022 day 4

main {
  const ubyte disk_drive = 8
  uword left
  uword right

  ; main
  sub start() {
    bool ok
    bool done
    ubyte[80] filename
    uword line
    uword line_count = 0
    uword part1_total
    uword part2_total
    byte low
    byte high
    ubyte i

    ; loop forever so we can process multiple files
    repeat {
      ; get filename and open
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

      ; initialize our counters
      part1_total = 0
      part2_total = 0
      line_count = 0

      done = false
      while not done {
        line = lines.readline()
        if line == lines.nil {
          done = true
        } else if string.length(line) > 0 {
          line_count += 1
          low = 0
          i = 0
          while line[i] != '-' {
            low = low * 10 + line[i] - '0'
            i+=1
          }
          high = 0
          i+=1
          while line[i] != ',' {
            high = high * 10 + line[i] - '0'
            i+=1
          }
          left = range.seq(low, high+1)
          i+=1
          low = 0
          while line[i] != '-' {
            low = low * 10 + line[i] - '0'
            i+=1
          }
          high = 0
          i+=1
          while line[i] {
            high = high * 10 + line[i] - '0'
            i+=1
          }
          right = range.seq(low, high+1)
          if range.contains(left, right) or range.contains(right, left) {
            part1_total += 1
          }
          if range.overlaps(left, right) {
            part2_total += 1
          }
          range.free(left)
          range.free(right)
        }
      }
      diskio.f_close()

      ; report results
      txt.print("read ")
      txt.print_uw(line_count)
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
