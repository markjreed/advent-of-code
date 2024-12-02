%zeropage basicsafe
%import DataLoader
%import ReportList
%import textio
%import syslib

main {
    sub start() {
        uword reportList = memory("reportList", ReportList.SIZE, 1)
        txt.lowercase()
        DataLoader.open("data.txt")
        uword total = 0
        ubyte i
        uword lines = 0
        bool debug
        do {
            ubyte count = DataLoader.get_reports(reportList)
            lines += 1
            ; debug = lines > 694 and lines < 714
            if debug {
                for  i in 0 to count - 1 {
                    txt.print_ub(ReportList.get_reports_item(reportList, i))
                    txt.chrout(' ')
                }
            }
            if ReportList.is_safe(reportList, debug)
                total += 1
            cbm.CLRCHN()
            ubyte key = cbm.GETIN2()
        } until (count == 0) or (key != 0)

        txt.print_uw(total)
        txt.nl()
    }
}
