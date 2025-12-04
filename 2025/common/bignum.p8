%import heap
%import strings
%import textio

bignum {
    struct Chunk {
        ^^Chunk next
        uword value
    } 

    struct Number {
        bool negative
        ubyte chunkCount;
        ^^Chunk first
        ^^Chunk last
    }

    sub newNumber() -> ^^Number {
        ^^Number result =  heap.alloc(sizeof(Number))
        result.chunkCount = 0
        result.first = result.last = heap.NIL
        return result
    }

    sub newChunk() -> ^^Chunk {
        ^^Chunk result = heap.alloc(sizeof(Chunk))
        result.next = heap.NIL
        result.value = 0
        return result
    }

    sub addChunk(^^Number number) -> ^^Chunk {
        if number.last == heap.NIL {
            number.first = newChunk()
            number.last = number.first
        } else {
            number.last.next = newChunk()
            number.last = number.last.next
        }
        number.chunkCount += 1
        number.last.value = 0
        number.last.next = heap.NIL
        return number.last
    }

    sub newFromByte(byte b) -> ^^Number {
        return newFromWord(b as word)
    }

    sub newFromUbyte(ubyte ub) -> ^^Number {
        return newFromUword(ub as uword)
    }

    sub newFromUword(uword uw) -> ^^Number {
        ^^Number result = newNumber()
        ^^Chunk chunk = addChunk(result)
        result.negative = false
        if uw >= 10000 {
            uword quotient
            divmod(uw, 10000, quotient, uw)
            chunk.value = quotient
            chunk = addChunk(result)
        }
        chunk.value = uw
        return result
    }

    sub newFromWord(word w) -> ^^Number {
        ^^Number result
        if w == -32768 {
            result = newFromUword(3)
            result.negative = true
            ^^Chunk chunk = addChunk(result)
            chunk.value = 2768
        } else if w < 0 {
            result = newFromUword(-w as uword)
            result.negative = true
        } else {
            result = newFromUword(w as uword)
        }
        return result
    }

    sub newFromString(^^ubyte s) -> ^^Number {
        ^^Number result = newNumber()
        ^^Chunk chunk = addChunk(result)

        while s^^ >= '0' and s^^ <= '9' {
            shiftLeft(result)
            chunk.value += s^^ - '0'
            s += 1
        }
        return result
    }

    
    sub shiftLeft(^^Number num) {
        ^^Chunk chunk = num.first
        ^^Chunk prev = heap.NIL

        while chunk != heap.NIL {
            if chunk.value >= 1000 {
                if prev == heap.NIL {
                    num.first = newChunk()
                    num.chunkCount += 1
                    num.first.next = chunk
                    prev = num.first
                }
                prev.value += chunk.value / 1000
                uword value = chunk.value % 1000
                chunk.value = value
             }
             chunk.value *= 10
             prev = chunk
             chunk = chunk.next
        }
    }

    sub inspectNum(^^Number num) {
        ^^Chunk chunk
        txt.print("Number@")
        txt.print_uwhex(num, true)
        txt.print(": negative=")
        txt.print_bool(num.negative)
        txt.chrout(' ')
        txt.print("chunkCount=")
        txt.print_ub(num.chunkCount)
        txt.nl()
        txt.print("              first=")
        txt.print_uwhex(num.first, true)
        txt.chrout(' ')
        txt.print("last=")
        txt.print_uwhex(num.last, true)
        txt.nl()
        chunk = num.first
        while chunk != heap.NIL {
            inspectChunk(chunk)
            chunk = chunk.next
        }
    }
    sub inspectChunk(^^Chunk chunk) {
        txt.print("Chunk@")
        txt.print_uwhex(chunk, true)
        txt.print(": value=")
        txt.print_uw(chunk.value)
        txt.chrout(' ')
        txt.print("next=")
        txt.print_uwhex(chunk.next, true)
        txt.nl()
    }

    sub freeChunk(^^Chunk chunk) {
        heap.free(chunk)
    }

    sub freeNumber(^^Number num) {
        ^^Chunk chunk = num.first
        ^^Chunk next
        while chunk != heap.NIL {
            next = chunk.next
            chunk.next = heap.NIL
            freeChunk(chunk)
            chunk = next
        }
        num.first = heap.NIL
        num.last = heap.NIL
        heap.free(num)
    }
}

txt {
    %option merge
    sub print_bn(^^bignum.Number n) {
        ^^bignum.Chunk chunk = n.first
        if n.negative {
            txt.chrout('-')
        }
        while chunk != heap.NIL {
            if chunk != n.first and chunk.value < 1000 {
                txt.chrout('0')
                if chunk.value < 100 {
                    txt.chrout('0')
                    if chunk.value < 10 {
                        txt.chrout('0')
                    }
                }
            }
            txt.print_uw(chunk.value)
            chunk = chunk.next
        }
    }
}
