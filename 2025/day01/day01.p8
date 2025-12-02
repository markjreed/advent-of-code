%zeropage basicsafe
%import aoc
%import conv
%import syslib

main {
    const ubyte DAY = 1
    const uword DIAL_SIZE = 100
    const bool DEBUG = false
    sub start() {
        ^^aoc.Puzzle puzzle = aoc.initPuzzle(DAY)
        if puzzle == aoc.NIL {
            txt.print("No data. Exiting.")
            txt.nl()
            sys.exit(1)
        }

        if DEBUG {
            txt.print("no,line,new,part1,part2\n")
            txt.print("0,,50,0,0\n")
        }

        ubyte dial = 50
        ubyte was
        ^^ubyte line 
        uword count, rotations
        uword part1 = 0
        uword part2 = 0
        bool left 
        uword lineno = 0
        
        while not puzzle.eof {
            line = aoc.readLine(puzzle)
            lineno += 1
            count = conv.str2uword(line + 1)
            divmod(count, DIAL_SIZE, rotations, count)
            left = line[0] == 'l'
            if left 
                count = DIAL_SIZE - count
            was = dial
            dial = (dial + (count % DIAL_SIZE as ubyte)) % DIAL_SIZE as ubyte
            if dial == 0 {
                part1 += 1
                part2 += 1
            } else if was != 0 and ((left and dial > was) or
                      ((not left) and dial < was)) {
                part2 += 1
            }
            part2 += rotations

            if DEBUG {
                txt.print_uw(lineno)
                txt.chrout(',')
                txt.print(line)
                txt.chrout(',')
                txt.print_ub(dial)
                txt.chrout(',')
                txt.print_uw(part1)
                txt.chrout(',')
                txt.print_uw(part2)
                txt.nl()
            }
        }
        txt.print_uw(part1)
        txt.nl()
        txt.print_uw(part2)
        txt.nl()
    }
}
