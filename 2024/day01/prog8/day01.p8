%zeropage basicsafe
%import KiloFloat
%import DataLoader
%import diskio
%import syslib
%import textio

main {
    sub start() {
        uword line
        float id1, id2, dist, total_dist
        float num, similarity_score

        uword list1 = memory("list1", KiloFloat.SIZE, 1)
        uword list2 = memory("list2", KiloFloat.SIZE, 1)

        uword lines = DataLoader.load("data.txt", list1, list2)

        KiloFloat.sort(list1)
        KiloFloat.sort(list2)

        total_dist = 0
        similarity_score = 0
        for line in 0 to lines - 1 {
            id1 = KiloFloat.get_data_item(list1, line)
            id2 = KiloFloat.get_data_item(list2, line)
            dist = abs(id1 - id2)
            total_dist += dist

            num = KiloFloat.get_data_item(list1, line)
            similarity_score += num * (KiloFloat.count(list2, num) as float)
        }
        txt.print_f(total_dist)
        txt.nl()
        txt.print_f(similarity_score)
        txt.nl()
    }
}
