%import syslib
%import textio

heap {
    const uword HEAP_SIZE = 8192
    const uword NIL = $0000
    uword Heap = memory("Heap", HEAP_SIZE, 1)
    uword nextBlock = Heap
    uword freeList = NIL

    struct Block {
        ^^Block next
        uword size
        uword data
    }

    sub alloc(uword size) -> uword {
        ^^Block prev = NIL
        ^^Block ptr = freeList
        while ptr != NIL {
            if ptr.size >= size {
                if prev == NIL {
                    freeList = ptr.next
                } else {
                    prev.next = ptr.next
                }
                ptr.next = NIL
                return ptr.data
            }
            prev = ptr
            ptr = ptr.next
        }
        ptr = nextBlock
        ptr.size = size
        nextBlock += sizeof(Block)
        ptr.data = nextBlock
        nextBlock += size
        if nextBlock - Heap >= HEAP_SIZE {
            txt.print("PANIC - out of memory.\n")
            sys.exit(1)
        }
        return ptr.data
    }
    
   sub free(uword data) {
       uword blockaddr = data - sizeof(Block)
       ^^Block ptr = blockaddr
       if ptr.data != data  {
            txt.print("PANIC: invalid heap block\n")
            sys.exit(1)
        }
       ptr.next = freeList
       freeList = ptr
   }
}
