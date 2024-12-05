%zeropage basicsafe
%import KiloFloat
%import DataLoader
%import diskio
%import syslib
%import textio

main {
    sub start() {
        uword[81] filename
        bool ok

        do {
            txt.print("enter filename: data.txt")
            repeat 8 { txt.chrout(157) }
            void txt.input_chars(filename)
            txt.nl()
            ok = diskio.f_open(filename)
            if not ok {
                txt.print("file not found.")
                txt.nl()
            }
            diskio.f_close()
        } until ok

        uword list1 = memory("list1", KiloFloat.SIZE, 1)
        uword list2 = memory("list2", KiloFloat.SIZE, 1)

        uword lines = DataLoader.load(filename, list1, list2)

        uword line
        float id1, id2, dist, total_dist
        float similarity_score

        KiloFloat.sort(list1)
        KiloFloat.sort(list2)

        total_dist = 0
        similarity_score = 0
        for line in 0 to lines - 1 {
            id1 = KiloFloat.get_data_item(list1, line)
            id2 = KiloFloat.get_data_item(list2, line)
            dist = abs(id1 - id2)
            total_dist += dist

            similarity_score += id1 * (KiloFloat.count(list2, id1) as float)
        }
        txt.print_f(total_dist)
        txt.nl()
        txt.print_f(similarity_score)
        txt.nl()
    }
}
