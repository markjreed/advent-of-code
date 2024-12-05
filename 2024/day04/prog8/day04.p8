%zeropage basicsafe
%import diskio
%import floats
%import textio

main {
    uword width, height
    const uword MAX_DATA_SIZE = 20000
    word[] deltas = [ -1, 0, 1 ]
    uword data = memory("data", MAX_DATA_SIZE, 2000)

    sub get(word i, word j) -> ubyte {
        if i < 0 or j < 0 or i >= height or j >= width {
            return 0
        }
        uword offset = i * (width + 1) + j as uword
        return @(data + offset)
    }

    sub start() {
        ubyte[81] filename
        bool ok
        uword bytes

        do {
            txt.print("enter filename: data.txt")
            repeat 8 { txt.chrout(157) }
            void txt.input_chars(filename)
            txt.nl()
            ok = diskio.f_open(filename)
            if ok {
                bytes = diskio.f_read(data, MAX_DATA_SIZE)
                diskio.f_close()
                if bytes == 0 {
                    txt.print("unable to read file.")
                    txt.nl()
                    ok = false
                }
                else if bytes == MAX_DATA_SIZE {
                    txt.print("file too large.")
                    txt.nl()
                    ok = false
                }
            } else {
                txt.print("file not found.")
                txt.nl()
            }
        } until ok

        width = 0
        while @(data + width) != 10 and @(data + width) != 13 {
            width += 1
        }
        height = bytes / (width + 1)  as ubyte

        uword xmas = 0
        uword x_mas = 0
        uword i, j
        word wi, wj, di, dj
        for i in 0 to height - 1 {
            wi = i as word
            for j in 0 to width - 1 {
                wj = j as word
                ubyte letter = get(wi, wj)
                if letter == iso:'X' {
                    for di in deltas {
                        if (0 <= i + 3 * di) and (i + 3 * di < height) {
                            for dj in deltas {
                                if (0 <= j + 3 * dj) and (j + 3 * dj < width) {
                                    if di != 0 or dj != 0 {
                                        if get(i +     di, j +     dj) == iso:'M' and
                                           get(i + 2 * di, j + 2 * dj) == iso:'A' and
                                           get(i + 3 * di, j + 3 * dj) == iso:'S' {
                                            xmas += 1
                                        } 
                                    }
                                }
                            }
                        }
                    }
                }
                if i > 0 and i < height - 1 and j > 0 and j < width - 1 and letter == iso:'A' {
                    if ((get(wi+1,wj-1) == iso:'M' and get(wi-1,wj+1) == iso:'S') or
                        (get(wi+1,wj-1) == iso:'S' and get(wi-1,wj+1) == iso:'M')) 
                    and
                       ((get(wi-1,wj-1) == iso:'S' and get(wi+1,wj+1) == iso:'M') or
                        (get(wi-1,wj-1) == iso:'M' and get(wi+1,wj+1) == iso:'S')) {
                        x_mas += 1
                    }
                }
            }
        }
        txt.print_uw(xmas)
        txt.nl()
        txt.print_uw(x_mas)
        txt.nl()
    }
}
