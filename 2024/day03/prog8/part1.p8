%import diskio
%import floats
%import syslib
%import textio
%zeropage basicsafe

main {
    sub start() {

        if not diskio.f_open("data.txt") {
           txt.print("no data file")
           txt.nl()
           sys.exit(1)
        }

        ubyte ch
        uword count
        uword num1, num2

        sub START() -> uword {
            if ch == iso:'m' {
                return &M_
            } else {
                return &START
            }
        }

        sub M_() -> uword {
            when ch {
                iso:'u'  -> { return &MU_ }
                iso:'m'  -> { return &M_  }
                else -> { return &START }
            }
        }

        sub MU_() -> uword {
            when ch {
                iso:'l'  -> { return &MUL_ }
                iso:'m'  -> { return &M_  }
                else -> { return &START }
            }
        }

        sub MUL_() -> uword {
            when ch {
                '('  -> { return &MUL_O_ }
                iso:'m'  -> { return &M_  }
                else -> { return &START }
            }
        }

        sub MUL_O_() -> uword {
            if ch >= '0' and ch <= '9' {
                num1 = ch - '0'
                return &MUL_O1_
            } else if ch == iso:'m' {
                return &M_
            } else {
                return &START
            }
        }

        sub MUL_O1_() -> uword {
            if ch >= '0' and ch <= '9' {
                num1 = num1 * 10 + ch - '0'
                return &MUL_O2_
            } else if ch == ',' {
                return &MUL_C_
            } else if ch == iso:'m' {
                return &M_
            } else {
                return &START
            }
        }

        sub MUL_O2_() -> uword {
            if ch >= '0' and ch <= '9' {
                num1 = num1 * 10 + ch - '0'
                return &MUL_O3_
            } else if ch == ',' {
                return &MUL_C_
            } else if ch == iso:'m' {
                return &M_
            } else {
                return &START
            }
        }

        sub MUL_O3_() -> uword {
            when ch {
                ','  -> { return &MUL_C_ }
                iso:'m'  -> { return &M_  }
                else -> { return &START }
            }
        }

        sub MUL_C_() -> uword {
            if ch >= '0' and ch <= '9' {
                num2 = ch - '0'
                return &MUL_C1_
            } else if ch == iso:'m' {
                return &M_
            } else {
                return &START
            }
        }

        sub MUL_C1_() -> uword {
            if ch >= '0' and ch <= '9' {
                num2 = num2 * 10 + ch - '0'
                return &MUL_C2_
            } else if ch == ')' {
                return MUL_DONE()
            } else if ch == iso:'m' {
                return &M_
            } else {
                return &START
            }
        }

        sub MUL_C2_() -> uword {
            if ch >= '0' and ch <= '9' {
                num2 = num2 * 10 + ch - '0'
                return &MUL_C3_
            } else if ch == ')' {
                return MUL_DONE()
            } else if ch == iso:'m' {
                return &M_
            } else {
                return &START
            }
        }

        sub MUL_C3_() -> uword {
            when ch {
                ')'  -> return MUL_DONE()
                iso:'m'  -> return &M_
                else -> return &START
            }
        }

        sub MUL_DONE() -> uword {
            total += (num1 as float) * (num2 as float)
            return &START
        }

        float total = 0.0
        uword state = &START

        repeat {

            count = diskio.f_read(&ch, 1)

            if count == 0 {
                break
            }

            state = call(state)
        }

        diskio.f_close()
        txt.print_f(total)
   }
}
