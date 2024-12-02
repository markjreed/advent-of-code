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
        float f, f2, diff, sum
        uword line

        KiloFloat.sort(list1)
        KiloFloat.sort(list2)
        sum = 0
        for line in 0 to lines - 1 {
            f = KiloFloat.get_data_item(list1, line)
            f2 = KiloFloat.get_data_item(list2, line)
            diff = abs(f - f2)
            sum += diff
        }
        txt.print_f(sum)
        txt.nl()
    }
}
