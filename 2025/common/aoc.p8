%import diskio
%import strings
%import textio

aoc  {
    struct Puzzle {
        bool eof
        ^^ubyte filename
    }

    const uword NIL = $0000
    ^^Puzzle puzzle = ^^Puzzle:[ false , NIL ]
    ubyte[81] buffer

    sub initPuzzle(ubyte day) -> ^^Puzzle {
        bool append_day

        txt.clear_screen()
        txt.lowercase()
        txt.print("AOC Day ")
        txt.print_ub(day)
        txt.print("\n\nData source - [S]ample, [U]ser, or [C]ustom: ")
        bool ok = false
        while not ok {
            when txt.waitkey() {
                's' -> {
                    txt.print("Sample")
                    txt.nl()
                    void strings.copy("sample", &buffer)
                    append_day = true
                    ok = true
                }
                'u' -> {
                    txt.print("User")
                    txt.nl()
                    void strings.copy("day", &buffer)
                    append_day = true
                    ok = true
                }
                'c' -> {
                    txt.print("Custom")
                    txt.nl()
                    txt.print("Enter filename: ")
                    void txt.input_chars(&buffer)
                    append_day = false
                    ok = true
                }
            }
        }
        if append_day {
            void strings.append(buffer, conv.str_ub0(day) + 1)
            void strings.append(buffer, ".txt")
        }
        puzzle.filename = &buffer
        if diskio.f_open(puzzle.filename) {
            puzzle.eof = false
            return puzzle
        } 
        txt.print("No data. Exiting.")
        txt.nl()
        sys.exit(1)
        ; compiler doesn't know that exit() precludes returning, so...
        return NIL
    }

    sub readLine(^^Puzzle p) -> ^^ubyte {
        if p.eof
            return NIL
        ubyte count
        ubyte status
        count, status = diskio.f_readline(&buffer)
        if status & 64 != 0
            p.eof = true
        return &buffer
    }

    sub report(str part1, str part2) {
        txt.print("Part 1: ") txt.print(part1) txt.nl()
        txt.print("Part 2: ") txt.print(part2) txt.nl()
    }

    sub report_ub(ubyte part1, ubyte part2) {
        txt.print("Part 1: ") txt.print_ub(part1) txt.nl()
        txt.print("Part 2: ") txt.print_ub(part2) txt.nl()
    }

    sub report_uw(uword part1, uword part2) {
        txt.print("Part 1: ") txt.print_uw(part1) txt.nl()
        txt.print("Part 2: ") txt.print_uw(part2) txt.nl()
    }
}
