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
        txt.nl()
        txt.print("Data source: [S]ample, [U]ser, or [C]ustom: ")
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
        } else {
            return NIL
        }
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
}
