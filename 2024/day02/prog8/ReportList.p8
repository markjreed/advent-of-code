%import ReportList_def
%import textio

ReportList {
    %option merge

    sub is_safe(uword reportList) -> bool {
        ubyte i
        ubyte count = get_count(reportList)
        if count == 0 return false

        bool decreasing = get_reports_item(reportList, 1) < get_reports_item(reportList, 0)
        for i in 1 to count - 1 {
            if decreasing != (get_reports_item(reportList, i) < get_reports_item(reportList, i - 1)) {
                return false
            }
            byte delta = abs(get_reports_item(reportList, i) as byte - get_reports_item(reportList, i - 1) as byte)
            if delta < 1 or delta > 3 {
                return false
            }
        }
        return true
    }

    sub is_safe_without(uword reportList, ubyte index) -> bool {
        ubyte i, j
        ubyte count = get_count(reportList)
        uword sublist = memory("sublist", SIZE, 1)

        set_count(sublist, count - 1)
        j = 0
        for i in 0 to count - 1 {
            if i != index {
                set_reports_item(sublist, j, get_reports_item(reportList, i))
                j += 1
            }
        }
        return is_safe(sublist)
    }
}
