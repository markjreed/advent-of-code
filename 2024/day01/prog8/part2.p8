%zeropage basicsafe
%import KiloFloat
%import DataLoader
%import diskio
%import syslib
%import textio

main {
    sub start() {
        uword list1 = memory("list1", KiloFloat.SIZE, 1)
        uword list2 = memory("list2", KiloFloat.SIZE, 1)
        uword lines = DataLoader.load("data.txt", list1, list2)
        float f, sum
        uword line

        sum = 0
        for line in 0 to lines - 1 {
            f = KiloFloat.get_data_item(list1, line)
            sum = sum + f * (KiloFloat.count(list2, f) as float)
        }
        txt.print_f(sum)
        txt.nl()
    }
}
