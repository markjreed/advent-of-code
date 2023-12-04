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
    const ubyte O_SET    = 0
    const uword O_BIT    = 1
    const ubyte T_SET    = 0
    const uword T_BIT    = 2
    const ubyte F_SET    = 0
    const uword F_BIT    = 4
    const ubyte E_SET    = 0
    const uword E_BIT    = 8
    const ubyte S_SET    = 0
    const uword S_BIT    = 16
    const ubyte N_SET    = 0
    const uword N_BIT    = 32
    const ubyte ON_SET   = 0
    const uword ON_BIT   = 64
    const ubyte TW_SET   = 0
    const uword TW_BIT   = 128
    const ubyte TH_SET   = 0
    const uword TH_BIT   = 256
    const ubyte FO_SET   = 0
    const uword FO_BIT   = 512
    const ubyte FI_SET   = 0
    const uword FI_BIT   = 1024
    const ubyte SI_SET   = 0
    const uword SI_BIT   = 2048
    const ubyte SE_SET   = 0
    const uword SE_BIT   = 4096
    const ubyte EI_SET   = 0
    const uword EI_BIT   = 8192
    const ubyte NI_SET   = 0
    const uword NI_BIT   = 16384
    const ubyte THR_SET  = 0
    const uword THR_BIT  = 32768
    const ubyte FOU_SET  = 1
    const uword FOU_BIT  = 1
    const ubyte FIV_SET  = 1
    const uword FIV_BIT  = 2
    const ubyte SEV_SET  = 1
    const uword SEV_BIT  = 4
    const ubyte EIG_SET  = 1
    const uword EIG_BIT  = 8
    const ubyte NIN_SET  = 1
    const uword NIN_BIT  = 16
    const ubyte THRE_SET = 1
    const ubyte THRE_BIT = 32
    const ubyte SEVE_SET = 1
    const uword SEVE_BIT = 64
    const ubyte EIGH_SET = 1
    const uword EIGH_BIT = 128

    sub init() {
        states[0] = 0
        states[1] = 0
    }

    ; handle the next character, return true if we match a digit here
    sub parse(ubyte ch) -> bool {
        bool matched = false
        if ch >= '0' and ch <= '9' {
            digit = ch - '0'
            init()
            return true
        }
        new_states[0] = 0
        new_states[1] = 0

        when ch {
            'o' -> new_states[O_SET] |=  O_BIT
            't' -> new_states[T_SET] |=  T_BIT
            'f' -> new_states[F_SET] |=  F_BIT
            's' -> new_states[S_SET] |=  S_BIT
            'e' -> new_states[E_SET] |=  E_BIT
            'n' -> new_states[N_SET] |=  N_BIT
        }

        if states[O_SET] & O_BIT {
            if ch == 'n' new_states[ON_SET] |= ON_BIT
        }

        if states[T_SET] & T_BIT {
            when ch {
              'w'  -> { new_states[TW_SET] |= TW_BIT }
              'h'  -> { new_states[TH_SET] |= TH_BIT }
            }
        }

        if states[F_SET] & F_BIT {
            when ch {
              'o'  -> { new_states[FO_SET] |= FO_BIT }
              'i'  -> { new_states[FI_SET] |= FI_BIT }
            }
        }

        if states[S_SET] & S_BIT {
            when ch {
              'i'  -> { new_states[SI_SET] |= SI_BIT }
              'e'  -> { new_states[SE_SET] |= SE_BIT }
            }
        }

        if states[E_SET] & E_BIT {
            if ch == 'i' { new_states[EI_SET] |= EI_BIT }
        }

        if states[N_SET] & N_BIT {
            if ch == 'i' { new_states[NI_SET] |= NI_BIT }
        }

        if states[ON_SET] & ON_BIT {
            if ch == 'e' {
              digit = 1
              matched = true
            }
        }

        if states[TW_SET] & TW_BIT {
            if ch == 'o' {
              digit = 2
              matched = true
            }
        }

        if states[TH_SET] & TH_BIT {
            if ch == 'r' { new_states[THR_SET] |= THR_BIT }
        }

        if states[FO_SET] & FO_BIT {
            if ch == 'u' { new_states[FOU_SET] |= FOU_BIT }
        }

        if states[FI_SET] & FI_BIT {
            if ch == 'v' { new_states[FIV_SET] |= FIV_BIT }
        }

        if states[SI_SET] & SI_BIT {
            if ch == 'x' {
              digit = 6
              matched = true
           }
        }

        if states[SE_SET] & SE_BIT {
            if ch == 'v' { new_states[SEV_SET] |= SEV_BIT }
        }

        if states[EI_SET] & EI_BIT {
            if ch == 'g' { new_states[EIG_SET] |= EIG_BIT }
        }

        if states[NI_SET] & NI_BIT {
            if ch == 'n' { new_states[NIN_SET] |= NIN_BIT }
        }

        if states[THR_SET] & THR_BIT {
            if ch == 'e' { new_states[THRE_SET] |= THRE_BIT }
        }

        if states[FOU_SET] & FOU_BIT {
            if ch == 'r' {
                digit = 4
                matched = true
            }
        }

        if states[FIV_SET] & FIV_BIT {
            if ch == 'e' {
                digit = 5
                matched = true
            }
        }

        if states[SEV_SET] & SEV_BIT {
            if ch == 'e' { new_states[SEVE_SET] |= SEVE_BIT }
        }

        if states[EIG_SET] & EIG_BIT {
            if ch == 'h' { new_states[EIGH_SET] |= EIGH_BIT }
        }

        if states[NIN_SET] & NIN_BIT { ; NIN|
            if ch == 'e' {
                digit = 9
                matched = true
            }
        }

        if states[THRE_SET] & THRE_BIT {
            if ch == 'e' {
                digit = 3
                matched = true
            }
        }

        if states[SEVE_SET] & SEVE_BIT {
            if ch == 'n' {
                digit = 7
                matched = true
            }
        }

        if states[EIGH_SET] & EIGH_BIT {
            if ch == 't' {
                digit = 8
                matched = true
            }
        }

        states[0] = new_states[0]
        states[1] = new_states[1]
        return matched
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
