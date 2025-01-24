50 constant SIZE
SIZE 2 / constant ORIGIN

variable grid1
SIZE SIZE * chars allot
variable grid2 
SIZE SIZE * chars allot

: cell@ SIZE * + + C@ ;
: cell! SIZE * + + C! ;

variable active
variable working
variable x
variable y
variable dy
variable dx
variable neighborhood
variable alive

grid1 active !
grid2 working !

: print-grid 
    SIZE 0 do I y !
        SIZE 0 do I x !
            dup x @ y @ cell@ if '#' else '.' then emit 
        loop
        cr
    loop
;

: next-gen 
    SIZE 0 do I y ! 
        SIZE 0 do I x ! 
            active @ x @ y @ cell@ alive c!
            0 neighborhood !
            3 0 do I 1 - dy !
                y @ dy @ + dup 0 > swap SIZE < and if 
                    3 0 do I 1 - dx !
                        x @ dx @ + dup 0 > swap SIZE < and if 
                            active @ x @ dx @ + y @ dy @ + cell@ if 1 neighborhood +! then
                        then
                    loop
                then
            loop

            neighborhood @ 3 < if 0 working @ x @ y @ cell! then
            neighborhood @ 3 = if 1 working @ x @ y @ cell! then
            neighborhood @ 4 = if alive @ working @ x @ y @ cell! then
            neighborhood @ 4 > if 0 working @ x @ y @ cell! then
        loop
    loop
    active @
    working @
    active !
    working !
;

: iterate 
    next-gen
    active @ print-grid
;

1 active @ ORIGIN 14 - ORIGIN 8 - cell!
1 active @ ORIGIN 13 - ORIGIN 8 - cell!
1 active @ ORIGIN 15 - ORIGIN 7 - cell!
1 active @ ORIGIN 14 - ORIGIN 7 - cell!
1 active @ ORIGIN 14 - ORIGIN 6 - cell!

: run active @ print-grid
    1105 0 do iterate loop
;

