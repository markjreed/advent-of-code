%zeropage basicsafe
%import diskio
%import textio
%import PageSet
%import Rules

main {
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

        uword rules = memory("rules", Rules.SIZE, 1)
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
        ubyte[32] pageList
        uword total = 0

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
                 ; txt.print("checking")
                 ; for i in 0 to pageNum - 1 {
                     ; txt.chrout(if i==0 ':' else ',')
                     ; txt.chrout(' ')
                     ; txt.print_ub(pageList[i])
                 ; }
                 ; txt.nl()
                 PageSet.clear(seen)
                 for i in 0 to pageNum - 1 {
                     PageSet.add(seen, pageList[i])
                     uword precedents = Rules.get_precedents_item(rules, pageList[i])
                     for j in 0 to MAX_PAGE {
                         if PageSet.contains(precedents, j) and PageSet.contains(pages, j) and not PageSet.contains(seen, j) {
                             ; txt.print("    not ok because page ")
                             ; txt.print_ub(j) 
                             ; txt.print(" must come before page ")
                             ; txt.print_ub(pageList[i]) 
                             ; txt.nl()
                             ok = false
                             break
                         }
                     }
                 }
                 if ok {
                     ; txt.print("ok")
                     ; txt.nl()
                     total += pageList[pageNum / 2]
                 }
             }
        } until status & 64 != 0
        txt.print_uw(total)
        txt.nl()

    }
}
