%import KiloFloat_def
KiloFloat {
    %option merge

    sub sort(uword kiloFloat) {
        uword[] gaps = [701, 301, 132, 57, 23, 10, 4, 1] 
        float temp, j_gap
        uword i, j, gap
        uword length = get_length(kiloFloat)
        for gap in gaps {
            i = gap
            while i < length {
                temp = get_data_item(kiloFloat, i)
                j = i
                while j >= gap {
                    j_gap = get_data_item(kiloFloat, j - gap)
                    if j_gap <= temp {
                        break
                    }
                    set_data_item(kiloFloat, j, j_gap)
                    j -= gap
                }
                set_data_item(kiloFloat, j, temp)
                i += 1
            }
        }
    }

    sub count(uword haystack, float needle) -> uword {
        uword i, total, length
        total = 0
        length = get_length(haystack)
        for i in 0 to length - 1 {
            if get_data_item(haystack, i) == needle {
                total += 1
            }
        }
        return total
    }

    sub print(uword kiloFloat) {
        uword i
        for i in 0 to get_length(kiloFloat) - 1 {
            txt.chrout( if i==0 '[' else ',' )
            txt.print_f( get_data_item(kiloFloat, i) )
        }
        txt.chrout(']')
    }
}
