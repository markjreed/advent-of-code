100 DIM P1(8),P2(8):FOR I=0 TO 8:READ P1(I),P2(I):NEXT
110 PRINT:FI$="":INPUT "FILENAME";FI$
120 IF FI$="" THEN PRINT "NEVER MIND": END
130 OPEN 1,8,2,FI$
140 GOSUB 500: IF DS=0 THEN 160
150 CLOSE 1:PRINT "COULD NOT OPEN FILE.":GOTO 110
160 P1=0: REM PART 1 TOTAL
170 P2=0: REM PART 1 TOTAL
180 FOR D=0 TO 1 STEP 0:REM WHILE NOT DONE
190 : GET#1, BY$:IF ST AND 64 THEN D=1
200 : BY=ASC(BY$)
210 : IF (BY>=ASC("A")) AND (BY<=ASC("C")) THEN E=BY-ASC("A")
220 : IF (BY<ASC("X")) OR (BY>ASC("Z")) THEN 240
230 : H=BY-ASC("X"):R=E*3+H:P1=P1+P1(R):P2=P2+P2(R)
240 NEXT D
250 PRINT "PART 1:"P1
260 PRINT "PART 2:"P2
270 END
280 REM PART 1, PART 2
290 DATA     4,      3: REM AX
300 DATA     8,      4: REM AY
310 DATA     3,      8: REM AZ
320 DATA     1,      1: REM AX
330 DATA     5,      5: REM AY
340 DATA     9,      9: REM AZ
350 DATA     7,      2: REM AX
360 DATA     2,      6: REM AY
370 DATA     6,      7: REM AZ
500 OPEN 15,8,15:INPUT#15,DS,DS$,T,S:CLOSE 15:RETURN
