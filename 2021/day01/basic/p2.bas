100 OPEN 1, 8, 0, "DATA.CBM"
110 IF ST AND 64 THEN 200
120 INPUT#1, N$
130 N = VAL(N$)
140 IF (A=0) OR (B=0) THEN 180
150 S = A + B + N
160 IF (P>0) AND (S>P) THEN I=I+1
170 P = S
180 A = B: B = N
190 GOTO 110
200 CLOSE 1
210 PRINT I