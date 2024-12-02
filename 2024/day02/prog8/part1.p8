%zeropage basicsafe
%import DataLoader
%import ReportList
%import textio

main {
    sub start() {
        uword reportList = memory("reportList", ReportList.SIZE, 1)
        txt.lowercase()
        DataLoader.open("data.txt")
        uword total = 0
        do {
            ubyte count = DataLoader.get_reports(reportList)
            if ReportList.is_safe(reportList)
                total += 1
        } until count == 0
        txt.print_uw(total)
        txt.nl()
    }
}
