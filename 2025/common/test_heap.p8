%zeropage basicsafe
%import heap
%import strings

main {
    struct Line {
        ^^Line next
        ^^ubyte data
    }

    sub start() {
        ^^Line buffer = heap.alloc(sizeof(Line))
        buffer.next = $0000
        buffer.data = heap.alloc(81)
        txt.lowercase()
        txt.print("What is your name? ")
        txt.input_chars(buffer.data)
        txt.nl()
        txt.print("Hello, ")
        txt.print(buffer.data)
        txt.print("!\n")
    }
}
