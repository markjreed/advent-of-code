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

        float total = 0.0
        bool doing = true


        sub START() -> uword {
            when ch {
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub D_() -> uword {
            when ch {
                iso:'o' -> return &DO_
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }
                
        sub M_() -> uword {
            when ch {
                iso:'u' -> return &MU_
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }
                
        sub DO_() -> uword {
            when ch {
                '('     -> return &DO_O_
                iso:'n' -> return &DON_
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub MU_() -> uword {
            when ch {
                iso:'l' -> return &MUL_
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }
                
        sub DO_O_() -> uword {
            when ch {
                ')' -> { 
                    doing = true
                    return &START
                }
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub DON_() -> uword {
            when ch {
                '\''    -> return &DON_A_
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub MUL_() -> uword {
            when ch {
                '('     -> return &MUL_O_
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub DON_A_() -> uword {
            when ch {
                iso:'t' -> return &DONT_
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub MUL_O_() -> uword {
            if ch >= '0' and ch <= '9' {
                num1 = ch - '0'
                return &MUL_O1
            } 
            when ch {
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub DONT_() -> uword {
            when ch {
                '('     -> return &DONT_O_
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub MUL_O1() -> uword {
            if ch >= '0' and ch <= '9' {
                num1 = num1 * 10 + ch - '0'
                return &MUL_O2_
            } 
            when ch {
                    ',' -> return &MUL_C_
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub DONT_O_() -> uword {
            when ch {
                ')' -> {
                    doing = false
                    return &START
                }
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub MUL_O2_() -> uword {
            if ch >= '0' and ch <= '9' {
                num1 = num1 * 10 + ch - '0'
                return &MUL_O3_
            } 
            when ch {
                    ',' -> return &MUL_C_
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub MUL_O3_() -> uword {
            when ch {
                    ',' -> return &MUL_C_
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub MUL_C_() -> uword {
            if ch >= '0' and ch <= '9' {
                num2 = ch - '0'
                return &MUL_C1_
            } 
            when ch {
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }
            
        sub MUL_C1_() -> uword {
            if ch >= '0' and ch <= '9' {
                num2 = num2 * 10 + ch - '0'
                return &MUL_C2_
            } 
            when ch {
                ')'     -> return MUL_DONE()
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub MUL_C2_() -> uword {
            if ch >= '0' and ch <= '9' {
                num2 = num2 * 10 + ch - '0'
                return &MUL_C3_
            } 
            when ch {
                ')'     -> return MUL_DONE()
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }
            
        sub MUL_C3_() -> uword {
            when ch {
                ')'     -> return MUL_DONE()
                iso:'d' -> return &D_
                iso:'m' -> return &M_
                else    -> return &START
            }
        }

        sub MUL_DONE() -> uword {
            if doing {
                total += (num1 as float) * (num2 as float)
            }
            return &START
        }
            
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
