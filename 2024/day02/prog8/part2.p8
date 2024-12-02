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
            ubyte i
            if ReportList.is_safe(reportList) {
                total += 1
            } else {
                for i in 0 to count - 1 {
                    if ReportList.is_safe_without(reportList, i) {
                        total += 1
                        break
                    }
                }
            }
        } until count == 0
        txt.print_uw(total)
        txt.nl()
    }
}
