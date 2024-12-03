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

            if state == START and ch == iso:'m' {
                state = M_
            } else if state == M_ and ch == iso:'u'  {
                state = MU_
            } else if state == MU_ and ch == iso:'l'  {
                state = MUL_
            } else if state == MUL_ and ch == '('  {
                state = MUL_O_
            } else if state == MUL_O_ and ch >= '0' and ch <= '9'  {
                state = MUL_O1_
                num1 = ch - '0'
            } else if state == MUL_O1_ and ch >= '0' and ch <= '9' {
                state = MUL_O2_
                num1 = num1 * 10 + ch - '0'
            } else if state == MUL_O1_ and ch == ',' {
                state = MUL_C_ 
            } else if state == MUL_O2_ and ch >= '0' and ch <= '9' {
                state = MUL_O3_
                num1 = num1 * 10 + ch - '0'
            } else if state == MUL_O2_ and ch == ',' {
                state = MUL_C_
            } else if state == MUL_O3_ and ch == ',' {
                state = MUL_C_
            } else if state == MUL_C_ and ch >= '0' and ch <= '9' {
                num2 = ch - '0'
                state = MUL_C1_
            } else if state == MUL_C1_ and ch >= '0' and ch <= '9' {
                num2 = num2 * 10 + ch - '0'
                state = MUL_C2_
            } else if state == MUL_C1_ and ch == ')' {
                state = MUL_DONE
            } else if state == MUL_C2_ and ch >= '0' and ch <= '9' {
                num2 = num2 * 10 + ch - '0'
                state = MUL_C3_
            } else if state == MUL_C2_ and ch == ')' {
                state = MUL_DONE
            } else if state == MUL_C3_ and ch == ')' {
                state = MUL_DONE
            } else if ch == iso:'m' {
                state = M_
            } else {
                state = START
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
