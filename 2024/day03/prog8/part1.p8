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

        const ubyte START    =  0
        const ubyte M_       =  1
        const ubyte MU_      =  2
        const ubyte MUL_     =  3
        const ubyte MUL_O_   =  4
        const ubyte MUL_O1_  =  5
        const ubyte MUL_O2_  =  6
        const ubyte MUL_O3_  =  7
        const ubyte MUL_C_   =  8
        const ubyte MUL_C1_  =  9
        const ubyte MUL_C2_  = 10
        const ubyte MUL_C3_  = 11
        const ubyte MUL_DONE = 12

        const uword START_M = mkword(START, iso:'m')
        const uword M_U     = mkword(M_, iso:'u')
        const uword MU_L    = mkword(MU_, iso:'l')
        const uword MUL_O   = mkword(MUL_, '(')
        const uword MUL_O_0 = mkword(MUL_O_, '0')
        const uword MUL_O_1 = mkword(MUL_O_, '1')
        const uword MUL_O_2 = mkword(MUL_O_, '2')
        const uword MUL_O_3 = mkword(MUL_O_, '3')
        const uword MUL_O_4 = mkword(MUL_O_, '4')
        const uword MUL_O_5 = mkword(MUL_O_, '5')
        const uword MUL_O_6 = mkword(MUL_O_, '6')
        const uword MUL_O_7 = mkword(MUL_O_, '7')
        const uword MUL_O_8 = mkword(MUL_O_, '8')
        const uword MUL_O_9 = mkword(MUL_O_, '9')
        const uword MUL_O1_0 = mkword(MUL_O1_, '0')
        const uword MUL_O1_1 = mkword(MUL_O1_, '1')
        const uword MUL_O1_2 = mkword(MUL_O1_, '2')
        const uword MUL_O1_3 = mkword(MUL_O1_, '3')
        const uword MUL_O1_4 = mkword(MUL_O1_, '4')
        const uword MUL_O1_5 = mkword(MUL_O1_, '5')
        const uword MUL_O1_6 = mkword(MUL_O1_, '6')
        const uword MUL_O1_7 = mkword(MUL_O1_, '7')
        const uword MUL_O1_8 = mkword(MUL_O1_, '8')
        const uword MUL_O1_9 = mkword(MUL_O1_, '9')
        const uword MUL_O1_C = mkword(MUL_O1_, ',')
        const uword MUL_O2_0 = mkword(MUL_O2_, '0')
        const uword MUL_O2_1 = mkword(MUL_O2_, '1')
        const uword MUL_O2_2 = mkword(MUL_O2_, '2')
        const uword MUL_O2_3 = mkword(MUL_O2_, '3')
        const uword MUL_O2_4 = mkword(MUL_O2_, '4')
        const uword MUL_O2_5 = mkword(MUL_O2_, '5')
        const uword MUL_O2_6 = mkword(MUL_O2_, '6')
        const uword MUL_O2_7 = mkword(MUL_O2_, '7')
        const uword MUL_O2_8 = mkword(MUL_O2_, '8')
        const uword MUL_O2_9 = mkword(MUL_O2_, '9')
        const uword MUL_O2_C = mkword(MUL_O2_, ',')
        const uword MUL_O3_C = mkword(MUL_O3_, ',')
        const uword MUL_C_0 = mkword(MUL_C_, '0')
        const uword MUL_C_1 = mkword(MUL_C_, '1')
        const uword MUL_C_2 = mkword(MUL_C_, '2')
        const uword MUL_C_3 = mkword(MUL_C_, '3')
        const uword MUL_C_4 = mkword(MUL_C_, '4')
        const uword MUL_C_5 = mkword(MUL_C_, '5')
        const uword MUL_C_6 = mkword(MUL_C_, '6')
        const uword MUL_C_7 = mkword(MUL_C_, '7')
        const uword MUL_C_8 = mkword(MUL_C_, '8')
        const uword MUL_C_9 = mkword(MUL_C_, '9')
        const uword MUL_C1_0 = mkword(MUL_C1_, '0')
        const uword MUL_C1_1 = mkword(MUL_C1_, '1')
        const uword MUL_C1_2 = mkword(MUL_C1_, '2')
        const uword MUL_C1_3 = mkword(MUL_C1_, '3')
        const uword MUL_C1_4 = mkword(MUL_C1_, '4')
        const uword MUL_C1_5 = mkword(MUL_C1_, '5')
        const uword MUL_C1_6 = mkword(MUL_C1_, '6')
        const uword MUL_C1_7 = mkword(MUL_C1_, '7')
        const uword MUL_C1_8 = mkword(MUL_C1_, '8')
        const uword MUL_C1_9 = mkword(MUL_C1_, '9')
        const uword MUL_C1_C = mkword(MUL_C1_, ')')
        const uword MUL_C2_0 = mkword(MUL_C2_, '0')
        const uword MUL_C2_1 = mkword(MUL_C2_, '1')
        const uword MUL_C2_2 = mkword(MUL_C2_, '2')
        const uword MUL_C2_3 = mkword(MUL_C2_, '3')
        const uword MUL_C2_4 = mkword(MUL_C2_, '4')
        const uword MUL_C2_5 = mkword(MUL_C2_, '5')
        const uword MUL_C2_6 = mkword(MUL_C2_, '6')
        const uword MUL_C2_7 = mkword(MUL_C2_, '7')
        const uword MUL_C2_8 = mkword(MUL_C2_, '8')
        const uword MUL_C2_9 = mkword(MUL_C2_, '9')
        const uword MUL_C2_C = mkword(MUL_C2_, ')')
        const uword MUL_C3_C = mkword(MUL_C3_, ')')

        ubyte state = START

        ubyte ch
        uword count
        uword num1, num2

        float total = 0.0

        repeat {

            count = diskio.f_read(&ch, 1)

            if count == 0 {
                break
            }

            when mkword(state, ch) {
                START_M -> { state = M_ } 
                M_U     -> { state = MU_ }
                MU_L    -> { state = MUL_ }
                MUL_O   -> { state = MUL_O_ }
                MUL_O_0 -> { state = MUL_O1_ num1 = 0 }
                MUL_O_1 -> { state = MUL_O1_ num1 = 1 }
                MUL_O_2 -> { state = MUL_O1_ num1 = 2 }
                MUL_O_3 -> { state = MUL_O1_ num1 = 3 }
                MUL_O_4 -> { state = MUL_O1_ num1 = 4 }
                MUL_O_5 -> { state = MUL_O1_ num1 = 5 }
                MUL_O_6 -> { state = MUL_O1_ num1 = 6 }
                MUL_O_7 -> { state = MUL_O1_ num1 = 7 }
                MUL_O_8 -> { state = MUL_O1_ num1 = 8 }
                MUL_O_9 -> { state = MUL_O1_ num1 = 9 }
                MUL_O1_0 -> { state = MUL_O2_ num1 = num1 * 10 }
                MUL_O1_1 -> { state = MUL_O2_ num1 = num1 * 10 + 1 }
                MUL_O1_2 -> { state = MUL_O2_ num1 = num1 * 10 + 2 }
                MUL_O1_3 -> { state = MUL_O2_ num1 = num1 * 10 + 3 }
                MUL_O1_4 -> { state = MUL_O2_ num1 = num1 * 10 + 4 }
                MUL_O1_5 -> { state = MUL_O2_ num1 = num1 * 10 + 5 }
                MUL_O1_6 -> { state = MUL_O2_ num1 = num1 * 10 + 6 }
                MUL_O1_7 -> { state = MUL_O2_ num1 = num1 * 10 + 7 }
                MUL_O1_8 -> { state = MUL_O2_ num1 = num1 * 10 + 8 }
                MUL_O1_9 -> { state = MUL_O2_ num1 = num1 * 10 + 9 }
                MUL_O1_C -> { state = MUL_C_ } 
                MUL_O2_0 -> { state = MUL_O3_ num1 = num1 * 10 }
                MUL_O2_1 -> { state = MUL_O3_ num1 = num1 * 10 + 1 }
                MUL_O2_2 -> { state = MUL_O3_ num1 = num1 * 10 + 2 }
                MUL_O2_3 -> { state = MUL_O3_ num1 = num1 * 10 + 3 }
                MUL_O2_4 -> { state = MUL_O3_ num1 = num1 * 10 + 4 }
                MUL_O2_5 -> { state = MUL_O3_ num1 = num1 * 10 + 5 }
                MUL_O2_6 -> { state = MUL_O3_ num1 = num1 * 10 + 6 }
                MUL_O2_7 -> { state = MUL_O3_ num1 = num1 * 10 + 7 }
                MUL_O2_8 -> { state = MUL_O3_ num1 = num1 * 10 + 8 }
                MUL_O2_9 -> { state = MUL_O3_ num1 = num1 * 10 + 9 }
                MUL_O2_C -> { state = MUL_C_ }
                MUL_O3_C -> { state = MUL_C_ }
                MUL_C_0 -> { state = MUL_C1_ num2 = 0 }
                MUL_C_1 -> { state = MUL_C1_ num2 = 1 }
                MUL_C_2 -> { state = MUL_C1_ num2 = 2 }
                MUL_C_3 -> { state = MUL_C1_ num2 = 3 }
                MUL_C_4 -> { state = MUL_C1_ num2 = 4 }
                MUL_C_5 -> { state = MUL_C1_ num2 = 5 }
                MUL_C_6 -> { state = MUL_C1_ num2 = 6 }
                MUL_C_7 -> { state = MUL_C1_ num2 = 7 }
                MUL_C_8 -> { state = MUL_C1_ num2 = 8 }
                MUL_C_9 -> { state = MUL_C1_ num2 = 9 }
                MUL_C1_0 -> { state = MUL_C2_ num2 = num2 * 10 }
                MUL_C1_1 -> { state = MUL_C2_ num2 = num2 * 10 + 1 }
                MUL_C1_2 -> { state = MUL_C2_ num2 = num2 * 10 + 2 }
                MUL_C1_3 -> { state = MUL_C2_ num2 = num2 * 10 + 3 }
                MUL_C1_4 -> { state = MUL_C2_ num2 = num2 * 10 + 4 }
                MUL_C1_5 -> { state = MUL_C2_ num2 = num2 * 10 + 5 }
                MUL_C1_6 -> { state = MUL_C2_ num2 = num2 * 10 + 6 }
                MUL_C1_7 -> { state = MUL_C2_ num2 = num2 * 10 + 7 }
                MUL_C1_8 -> { state = MUL_C2_ num2 = num2 * 10 + 8 }
                MUL_C1_9 -> { state = MUL_C2_ num2 = num2 * 10 + 9 }
                MUL_C1_C -> { state = MUL_DONE } 
                MUL_C2_0 -> { state = MUL_C3_ num2 = num2 * 10 }
                MUL_C2_1 -> { state = MUL_C3_ num2 = num2 * 10 + 1 }
                MUL_C2_2 -> { state = MUL_C3_ num2 = num2 * 10 + 2 }
                MUL_C2_3 -> { state = MUL_C3_ num2 = num2 * 10 + 3 }
                MUL_C2_4 -> { state = MUL_C3_ num2 = num2 * 10 + 4 }
                MUL_C2_5 -> { state = MUL_C3_ num2 = num2 * 10 + 5 }
                MUL_C2_6 -> { state = MUL_C3_ num2 = num2 * 10 + 6 }
                MUL_C2_7 -> { state = MUL_C3_ num2 = num2 * 10 + 7 }
                MUL_C2_8 -> { state = MUL_C3_ num2 = num2 * 10 + 8 }
                MUL_C2_9 -> { state = MUL_C3_ num2 = num2 * 10 + 9 }
                MUL_C2_C -> { state = MUL_DONE }
                MUL_C3_C -> { state = MUL_DONE }
                else -> {
                    when ch {
                        iso:'m' -> { state = M_ }
                        else -> { state = START }
                    }
                }
            }

            if state == MUL_DONE {
                total += (num1 as float) * (num2 as float)
                state = START
            }
        }

        diskio.f_close()
        txt.print_f(total)
   }
}
