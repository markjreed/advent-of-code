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

        const ubyte START     =  0
        const ubyte M_        =  1
        const ubyte D_        =  2
        const ubyte MU_       =  3
        const ubyte DO_       =  4
        const ubyte MUL_      =  5
        const ubyte DO_O_     =  6
        const ubyte DON_      =  7
        const ubyte MUL_O_    =  8
        const ubyte DON_A_    =  9
        const ubyte MUL_O1_   = 10
        const ubyte DONT_     = 11
        const ubyte MUL_C_    = 12
        const ubyte MUL_O2_   = 13
        const ubyte DONT_O_   = 14
        const ubyte MUL_C1_   = 15
        const ubyte MUL_O3_   = 16
        const ubyte MUL_DONE  = 17
        const ubyte MUL_C2_   = 18
        const ubyte MUL_C3_   = 19

        ubyte state = START

        repeat {
            count = diskio.f_read(&ch, 1)

            if count == 0 {
                break
            }

            if state == START and ch == iso:'m' {
                state = M_
            } else if state == START and ch == iso:'d' {
                state = D_
            } else if state == M_ and ch == iso:'u'  {
                state = MU_
            } else if state == D_ and ch == iso:'o'  {
                state = DO_
            } else if state == MU_ and ch == iso:'l'  {
                state = MUL_
            } else if state == DO_ and ch == '('  {
                state = DO_O_
            } else if state == DO_ and ch == iso:'n'  {
                state = DON_
            } else if state == MUL_ and ch == '('  {
                state = MUL_O_
            } else if state == DO_O_ and ch == ')'  {
                state = START
                doing = true
            } else if state == DON_ and ch == '\''  {
                state = DON_A_
            } else if state == MUL_O_ and ch >= '0' and ch <= '9' {
                state = MUL_O1_
                num1 = ch - '0'
            } else if state == DON_A_ and ch == iso:'t' {
                state = DONT_
            } else if state == MUL_O1_ and ch == ',' {
                state = MUL_C_
            } else if state == MUL_O1_ and ch >= '0' and ch <= '9' {
                state = MUL_O2_
                num1 = num1 * 10 + ch - '0'
            } else if state == DONT_ and ch == '(' {
                state = DONT_O_
            } else if state == MUL_C_ and ch >= '0' and ch <= '9'  {
                state = MUL_C1_
                num2 = ch - '0'
            } else if state == MUL_O2_ and ch == ',' {
                state = MUL_C_
            } else if state == MUL_O2_ and ch >= '0' and ch <= '9' {
                state = MUL_O3_
                num1 = num1 * 10 + ch - '0'
            } else if state == DONT_O_ and ch == ')' {
                state = START
                doing = false
            } else if state == MUL_C1_ and ch == ')' {
                state = MUL_DONE
            } else if state == MUL_C1_ and ch >= '0' and ch <= '9' {
                state = MUL_C2_
                num2 = num2 * 10 + ch - '0'
            } else if state == MUL_O3_ and ch == ',' {
                state = MUL_C_
            } else if state == MUL_C2_ and ch == ')' {
                state = MUL_DONE
            } else if state == MUL_C2_ and ch >= '0' and ch <= '9' {
                state = MUL_C3_
                num2 = num2 * 10 + ch - '0'
            } else if state == MUL_C3_ and ch == ')' {
                state = MUL_DONE
            } else if ch == iso:'m' {
                state = M_
            } else if ch == iso:'d' {
                state = D_
            } else {
                state = START 
            }

            if state == MUL_DONE {
                state = START 
                if doing { 
                    total += (num1 as float) * (num2 as float)
                }
            }
        }

        diskio.f_close()
        txt.print_f(total)
   }
}
