: check-usage ( -- )
    next-arg 2dup 0 0 d=  if 
        s" Usage: " sourcefilename s"  filename" s+ s+ stderr write-line throw 
        bye
    then
;
check-usage

0 Value fd-in
0 Value fd-out
: open-input ( addr u -- )  r/o open-file throw to fd-in ;
: open-output ( addr u -- )  w/o create-file throw to fd-out ;

open-input

256 value max-line
create line-buffer
max-line 2 + chars allot

line-buffer max-line fd-in read-line  throw drop 
value SIZE

create grid1
SIZE SIZE * chars allot
create grid2 
SIZE SIZE * chars allot
create grid3 
SIZE SIZE * chars allot

: cell@ ( grid x y -- cell ) SIZE * + + C@ ;
: cell! ( cell grid x y -- ) SIZE * + + C! ;

variable active
variable working
variable x
variable y
variable alive
variable buf

grid1 active !
grid2 working !

( load a line of cells from a string into the currently active grid at row y)
: load-line ( addr count -- ) 
    0 x !
    0 do
        dup I + c@ '#' = active @ x @ y @ cell!
        1 x +!
    loop
;
        
line-buffer SIZE load-line 

: load-file ( -- )
    begin
        line-buffer max-line fd-in read-line throw 
    while
        1 y +!
        line-buffer swap load-line
    repeat
;
    
: save-grid
    SIZE 0 do I y !
        SIZE 0 do I x !
            active @ x @ y @ cell@ grid3 x @ y @ cell!
        loop
    loop
;

: load-grid
    SIZE 0 do I y !
        SIZE 0 do I x !
            grid3 x @ y @ cell@ active @ x @ y @ cell!
        loop
    loop
;

load-file
save-grid 

: print-grid ( grid -- )
    SIZE 0 do I y !
        SIZE 0 do I x !
            dup x @ y @ cell@ if '#' else '.' then emit 
        loop
        cr
    loop
;

variable cx 
variable cy 
variable neighborhood
variable dy
variable dx
: count-neighbors ( x y - n )
    0 neighborhood !
    cy ! cx !
    3 0 do I 1 - dy !
        cy @ dy @ + dup 0 >= swap SIZE < and if 
            3 0 do I 1 - dx !
                cx @ dx @ + dup 0 >= swap SIZE < and if 
                    active @ cx @ dx @ + cy @ dy @ + cell@ if 1 neighborhood +! then
                then
            loop
        then
    loop
    neighborhood @
;

: next-gen ( -- )
    SIZE 0 do I y ! 
        SIZE 0 do I x ! 
            active @ x @ y @ cell@ alive !
            x @ y @ count-neighbors
            dup 3 < if 0 working @ x @ y @ cell! then
            dup 3 = if 1 working @ x @ y @ cell! then
            dup 4 = if alive @ working @ x @ y @ cell! then
            4 > if 0 working @ x @ y @ cell! then
        loop
    loop
    active @
    working @
    active !
    working !
;

: iterate 
    next-gen
;

: fix4 
    1 active @
    2dup 0 0 cell!
    2dup SIZE 1 - 0 cell!
    2dup 0 SIZE 1 - cell!
    SIZE 1 - dup cell!
;

: iterate2
    fix4
    next-gen
    fix4
;

: population ( -- )
    0 
    SIZE 0 do I y ! 
        SIZE 0 do I x ! 
            active @ x @ y @ cell@ if 1 + then
        loop
    loop
;

: run ( generations -- ) 
    0 do
        iterate
    loop
;

: run2 ( generations -- ) 
    0 do
        iterate2
    loop
;

next-arg 0 s>d 2swap >number 2drop d>s value generations 
generations run
population .  cr
load-grid
generations run2
population .  cr
bye
