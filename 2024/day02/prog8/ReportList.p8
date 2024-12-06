%import ReportList_def
%import textio

ReportList {
    %option merge

    ; return a new list with the given element removed
    sub remove(uword reportList, ubyte index) -> uword {
        ubyte i, j
        ubyte count = get_count(reportList)
        uword subList = memory("subList", SIZE, 1)

        set_count(subList, count - 1)
        j = 0
        for i in 0 to count - 1 {
            if i != index {
                set_reports_item(subList, j, get_reports_item(reportList, i))
                j += 1
            }
        }
        return subList
    }

    sub is_safe(uword reportList, bool debug) -> bool {
        ubyte i
        if debug print(reportList)
        ubyte count = get_count(reportList)
        if count == 0 return false

        bool decreasing = get_reports_item(reportList, 1) < get_reports_item(reportList, 0)
        for i in 1 to count - 1 {
            if decreasing != (get_reports_item(reportList, i) < get_reports_item(reportList, i - 1)) {
                if debug  {
                    txt.print(": UNSAFE - not sorted")
                    txt.nl()
                }
                return false
            }
            ubyte prev = get_reports_item(reportList, i - 1)
            ubyte curr = get_reports_item(reportList, i)
            byte delta = abs( curr as byte - prev as byte )
            if delta < 1 or delta > 3 {
                if debug {
                    txt.print(": UNSAFE - ")
                    txt.print_ub(prev)
                    txt.print(" to ")
                    txt.print_ub(curr)
                    txt.print(" is a delta of ")
                    txt.print_b(delta)
                    txt.nl()
                }
                return false
            }
        }
        if debug {
            txt.print(": SAFE")
            txt.nl()
        }
        return true
    }

    sub print(uword reportList) {
        ubyte i
        for i in 0 to get_count(reportList) - 1 {
            txt.chrout(if i==0 '[' else ',')
            txt.print_ub(get_reports_item(reportList, i))
        }
        txt.chrout(']')
    }
}
