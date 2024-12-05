%import PageSet
%import Rules_def

Rules {
    %option merge
    sub addRule(uword rules, ubyte first, ubyte second) {
        uword pageSet = get_precedents_item(rules, second)
        PageSet.add(pageSet, first)
    }
    sub print(uword rules) {
        ubyte i,j
        for i in 0 to 99 {
            bool printed = false
            uword precedents = Rules.get_precedents_item(rules, i)
            for j in 0 to 99 {
                if PageSet.contains(precedents, j) {
                    if not printed {
                       txt.print("pageSet for page ") txt.print_ub(i) txt.print(" is at ")
                       txt.print_uwhex(precedents, true) txt.nl()
                       printed = true
                    }
                    txt.print_ub(j)
                    txt.chrout('>')
                    txt.print_ub(i)
                    txt.chrout(',')
                }
            }
        }
        txt.nl()
    }
}
