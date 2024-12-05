%import PageSet_def
%import syslib

PageSet {
    %option merge
    sub clear(uword pageSet) {
        sys.memset(pageSet, SIZE, 0)
    }

    sub add(uword pageSet, ubyte page) {
        ubyte byteIndex = page >> 3
        ubyte bitMask  = 1 << (page & 7)
        pageSet[byteIndex] |= bitMask
    }

    sub remove(uword pageSet, ubyte page) {
        ubyte byteIndex = page >> 3
        ubyte bitMask  = 1 << (page & 7)
        pageSet[byteIndex] &= ~bitMask
    }

    sub contains(uword pageSet, ubyte page) -> bool {
        ubyte byteIndex = page >> 3
        ubyte bitMask  = 1 << (page & 7)
        return (pageSet[byteIndex] & bitMask) != 0
    }
    
}
