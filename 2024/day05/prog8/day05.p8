%zeropage basicsafe
%import diskio
%import textio
%import PageSet
%import Rules

main {
    const ubyte MAX_PAGES = 32
    uword rules = memory("rules", Rules.SIZE, 1)

    ; compare two pages according to the ordering rules
    sub compare(ubyte page1, ubyte page2) -> byte {
        uword prec1 = Rules.get_precedents_item(rules, page1)
        uword prec2 = Rules.get_precedents_item(rules, page2)
        if PageSet.contains(prec1, page2) {
            return 1
        } else if PageSet.contains(prec2, page1) {
            return -1
        } else {
            return 0
        }
    }

    ; sort a list of pages according to the ordering rules
    ; the longest page list is less than 32 entries, so we just do a simple
    ; bubble sort 
    sub sort(uword pageList, ubyte pageCount) {
        ubyte pass, i, temp
        for pass in 1 to pageCount - 1 {
            for i in 0 to pageCount - pass {
                if compare(pageList[i], pageList[i+1]) > 0 {
                    temp = pageList[i]
                    pageList[i] = pageList[i+1]
                    pageList[i+1] = temp
                }
            }
        }
    }

    sub start() {
        ubyte[81] line
        bool ok
        ubyte bytes
        ubyte status, i, j
        const ubyte MAX_PAGE = 99

        do {
            txt.print("enter filename: data.txt")
            repeat 8 { txt.chrout(157) }
            void txt.input_chars(line)
            txt.nl()
            ok = diskio.f_open(line)
            if not ok {
                txt.print("file not found.")
                txt.nl()
            }
        } until ok

        sys.memset(rules, Rules.SIZE, 0)
        do {
            bytes, status = diskio.f_readline(line) 
            if bytes != 0 {
                ubyte first, second, second_start
                first = line[0] - '0'
                second_start = 3
                if line[1] >= '0' and line[1] <= '9' {
                    first = first * 10 + line[1] - '0'
                } else if line[1] == '|' {
                    second_start = 2
                }
                second = line[second_start] - '0'
                if line[second_start + 1] >= '0' and line[second_start + 1] <= '9' {
                    second = second * 10 + line[second_start + 1] - '0'
                }
                Rules.addRule(rules, first, second)
            }
        } until bytes == 0

        uword seen = memory("seen", PageSet.SIZE, 1)
        uword pages = memory("pages", PageSet.SIZE, 1)
        ubyte[MAX_PAGES] pageList
        uword part1 = 0
        uword part2 = 0

        do {
            bytes, status = diskio.f_readline(line) 
            if bytes != 0 {
                PageSet.clear(pages)
                sys.memset(pageList, 32, 0)
                ubyte pageNum = 0
                for i in 0 to bytes - 1 {
                    if line[i] >= '0' and line[i] <= '9' {
                        pageList[pageNum] = pageList[pageNum] * 10 + line[i] - '0'
                    } else if line[i] == ',' {
                        PageSet.add(pages, pageList[pageNum])
                        pageNum += 1
                        pageList[pageNum] = 0
                    }
                 }
                 if pageList[pageNum] != 0 {
                     PageSet.add(pages, pageList[pageNum])
                     pageNum += 1
                 }
                 ok = true
                 PageSet.clear(seen)
                 for i in 0 to pageNum - 1 {
                     PageSet.add(seen, pageList[i])
                     uword precedents = Rules.get_precedents_item(rules, pageList[i])
                     for j in 0 to MAX_PAGE {
                         if PageSet.contains(precedents, j) and PageSet.contains(pages, j) and not PageSet.contains(seen, j) {
                             ok = false
                             break
                         }
                     }
                 }
                 if ok {
                     part1 += pageList[pageNum / 2]
                 } else {
                     sort(pageList, pageNum)
                     part2 += pageList[pageNum / 2]
                 }
             }
        } until status & 64 != 0
        txt.print_uw(part1)
        txt.nl()
        txt.print_uw(part2)
        txt.nl()
    }
}
