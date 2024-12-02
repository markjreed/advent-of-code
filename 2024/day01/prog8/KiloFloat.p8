%import KiloFloat_def
KiloFloat {
    %option merge
    const uword LENGTH = 1000

    sub sort(uword kilofloat) {
        uword[] gaps = [701, 301, 132, 57, 23, 10, 4, 1] 
        float temp, j_gap
        uword i, j, gap
        for gap in gaps {
            i = gap
            while i < LENGTH {
                temp = get_data_item(kilofloat, i)
                j = i
                while j >= gap {
                    j_gap = get_data_item(kilofloat, j - gap)
                    if j_gap <= temp {
                        break
                    }
                    set_data_item(kilofloat, j, j_gap)
                    j -= gap
                }
                set_data_item(kilofloat, j, temp)
                i += 1
            }
        }
    }

    sub count(uword haystack, float needle) -> uword {
        uword i, total
        total = 0
        for i in 0 to LENGTH - 1 {
            if get_data_item(haystack, i) == needle {
                total += 1
            }
        }
        return total
    }
}
