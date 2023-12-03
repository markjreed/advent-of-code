%zeropage basicsafe
%import diskio
%import floats
%import string
%import syslib
%import textio

; NFA to recognize digits during one pass through line
recognizer {
    ubyte digit
    uword[2] states = [ 0, 0 ]
    uword[2] new_states = [ 0, 0 ]

    sub init() {
        states[0] = 0
        states[1] = 0
    }

    ; handle the next character, return true if we match a digit here
    sub parse(ubyte ch) -> bool {
        if ch >= '0' and ch <= '9' {
            digit = ch - '0'
            init()
            return true
        }
        new_states[0] = 0
        new_states[1] = 0

        when ch {
            'o' -> new_states[0] = new_states[0] | 1
            't' -> new_states[0] = new_states[0] | 2
            'f' -> new_states[0] = new_states[0] | 4
            's' -> new_states[0] = new_states[0] | 8
            'e' -> new_states[0] = new_states[0] | 16
            'n' -> new_states[0] = new_states[0] | 32
        }

        if states[0] & 1 { ; seen O
            if ch == 'n' {
              new_states[0] = new_states[0] | 64
            }
        }

        if states[0] & 2 { ; seen T
            when ch {
              'w'  -> { new_states[0] = new_states[0] | 128    }
              'h'  -> { new_states[0] = new_states[0] | 256    }
            }
        }

        if states[0] & 4 { ; seen F
            when ch {
              'o'  -> { new_states[0] = new_states[0] |  512   }
              'i'  -> { new_states[0] = new_states[0] | 1024   }
            }
        }

        if states[0] & 8 { ; seen S
            when ch {
              'i'  -> { new_states[0] = new_states[0] | 2048   }
              'e'  -> { new_states[0] = new_states[0] | 4096   }
            }
        }

        if states[0] & 16 { ; seen E
            if ch == 'i' { new_states[0] = new_states[0] | 8192   }
        }

        if states[0] & 32 { ; seen N
            if ch == 'i' { new_states[0] = new_states[0] | 16384   }
        }

        if states[0] & 64 { ; seen ON
            if ch == 'e' { 
              digit = 1
              states[0] = new_states[0]
              states[1] = new_states[1]
              return true
            }
        }

        if states[0] & 128 { ; seen TW
            if ch == 'o' { 
              digit = 2
              states[0] = new_states[0]
              states[1] = new_states[1]
              return true
            }
        }

        if states[0] & 256 { ; seen TH
            if ch == 'r' { new_states[0] = new_states[0] | 32768 }
        }

        if states[0] & 512 { ; seen FO
            if ch == 'u' { new_states[1] = new_states[1] | 1 }
        }

        if states[0] & 1024 { ; seen FI
            if ch == 'v' { new_states[1] = new_states[1] | 2 }
        }

        if states[0] & 2048 { ; seen SI
            if ch == 'x' {
              digit = 6
              states[0] = new_states[0]
              states[1] = new_states[1]
              return true
           }
        }

        if states[0] & 4096 { ; seen SE
            if ch == 'v' { new_states[1] = new_states[1] | 4 }
        }

        if states[0] & 8192 { ; seen EI
            if ch == 'g' { new_states[1] = new_states[1] | 8 }
        }

        if states[0] & 16384 { ; seen NI
            if ch == 'n' { new_states[1] = new_states[1] | 16 }
        }

        if states[0] & 32768 { ; seen THR
            if ch == 'e' { new_states[1] = new_states[1] | 32 }
        }

        if states[1] & 1 { ; seen FOU
            if ch == 'r' {
                digit = 4
                states[0] = new_states[0]
                states[1] = new_states[1]
                return true
            }
        }

        if states[1] & 2 { ; seen FIV
            if ch == 'e' {
                digit = 5
                states[0] = new_states[0]
                states[1] = new_states[1]
                return true
            }
        }

        if states[1] & 4 { ; seen SEV
            if ch == 'e' { new_states[1] = new_states[1] | 64 }
        }

        if states[1] & 8 { ; seen EIG
            if ch == 'h' { new_states[1] = new_states[1] | 128 }
        }

        if states[1] & 16 { ; seen NIN
            if ch == 'e' {
                digit = 9
                states[0] = new_states[0]
                states[1] = new_states[1]
                return true
            }
        }

        if states[1] & 32 { ; seen THRE
            if ch == 'e' {
                digit = 3
                states[0] = new_states[0]
                states[1] = new_states[1]
                return true
            }
        }

        if states[1] & 64 { ; seen SEVE
            if ch == 'n' {
                digit = 7
                states[0] = new_states[0]
                states[1] = new_states[1]
                return true
            }
        }

        if states[1] & 128 { ; seen EIGH
            if ch == 't' {
                digit = 8
                states[0] = new_states[0]
                states[1] = new_states[1]
                return true
            }
        }

        states[0] = new_states[0]
        states[1] = new_states[1]
        return false
    }
}

main {
    str filename="input.seq"
    const uword nil = 0
    const uword buffer = $a000
    uword buflen

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
        uword i
        ubyte ch
        ubyte first
        ubyte last
        uword total
        ubyte value
        ubyte eof = false

        if not diskio.f_open(filename) {
          txt.print(diskio.status())
          txt.nl()
          sys.exit(1)
        }
        total = 0
        first = 10
        while not eof {
            buflen = diskio.f_read(buffer, 512)
            eof = buflen < 512
            for i in 0 to buflen - 1 {
                ch = @(buffer + i)
                if ch == 13 {
                    value =  first*10 + last
                    total = total + value
                    first = 10
                    recognizer.init()
                }
                if recognizer.parse(ch) {
                    last = recognizer.digit
                    if first > 9 {
                        first = last
                    }
                }
            }
        }
        txt.print_uw(total)
        txt.nl()
        floats.print_f(ti())
        txt.nl()
    }
}
