%zeropage basicsafe
%import DataLoader
%import ReportList
%import textio

main {
    sub start() {
        bool debug = false
        if debug txt.lowercase()

        uword[81] filename
        bool ok

        do {
            txt.print("enter filename: data.txt")
            repeat 8 { txt.chrout(157) }
            void txt.input_chars(filename)
            txt.nl()
            ok = diskio.f_open(filename)
            if not ok {
                txt.print("file not found.")
                txt.nl()
            }
            diskio.f_close()
        } until ok

        DataLoader.open(filename)

        uword reportList = memory("reportList", ReportList.SIZE, 1)

        uword part1 = 0
        uword part2 = 0

        do {
            ubyte count = DataLoader.get_reports(reportList)
            if count != 0 {
                ubyte i
                if ReportList.is_safe(reportList, debug) {
                    part1 += 1
                    part2 += 1
                } else {
                    for i in 0 to count - 1 {
                        if ReportList.is_safe_without(reportList, i, debug) {
                            part2 += 1
                            break
                        }
                    }
                }
            }
        } until count == 0
        txt.print_uw(part1)
        txt.nl()
        txt.print_uw(part2)
        txt.nl()
    }
}
