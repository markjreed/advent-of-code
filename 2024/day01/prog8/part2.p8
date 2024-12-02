%zeropage basicsafe
%import KiloFloat
%import DataLoader
%import diskio
%import syslib
%import textio

main {
    sub start() {
        uword line
        float num, similarity_score

        uword list1 = memory("list1", KiloFloat.SIZE, 1)
        uword list2 = memory("list2", KiloFloat.SIZE, 1)

        uword lines = DataLoader.load("data.txt", list1, list2)

        similarity_score = 0
        for line in 0 to lines - 1 {
            num = KiloFloat.get_data_item(list1, line)
            similarity_score = similarity_score + num * (KiloFloat.count(list2, num) as float)
        }
        txt.print_f(similarity_score)
        txt.nl()
    }
}
