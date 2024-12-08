GETFILE:
  PRINT "CHOOSE INPUT FILE ([1]=SAMPLE.SEQ [2]=INPUT.SEQ):";
GETKEY:
  GET KEY$: IF KEY$="" THEN GETKEY
  IF KEY$<>"1" AND KEY$<>"2" AND KEY$<>"S" AND KEY$<>"I" AND KEY$<>"Q" THEN GETKEY
  IF KEY$="Q" THEN PRINT "QUIT": END
  IF KEY$="1" OR KEY$="S" THEN FILE$="SAMPLE.SEQ":GOTO GOTFILE
  FILE$="INPUT.SEQ"
GOTFILE:
  PRINT FILE$
  OPEN 1,8,2,FILE$
  OPEN 15,8,15:INPUT#15,DS,DS$,T,S:CLOSE 15
  IF DS THEN CLOSE 1:PRINT DS$:GOTO GETFILE

  DIGIT=0:PART=1:TI=0
START:
  LEFT = 0
  RIGHT = 1
  DIM WINNING(9), NUMBERS(24), COUNTS(218)
  COUNTS.LENGTH = 0
  CARD.NO = -1
  FOR EOF=0 TO 1 STEP 0
    LINPUT#1, CARD$
    CARD.NO = CARD.NO + 1
    N = CARD.NO:GOSUB APPEND.COUNT
    EOF = (ST AND 64)/64
    WINNING.LENGTH = 0
    NUMBERS.LENGTH = 0
    SIDE = LEFT
    GOSUB SKIP.LABEL
    FOR DONE = 0 TO 1 STEP 0
      GOSUB GET.TOKEN
      IF TOKEN$ = "" THEN EXIT.LOOP
      IF VAL(TOKEN$)=0 THEN NOT.DIGIT
      IF SIDE = RIGHT THEN FOUND.NUM
      WINNING(WINNING.LENGTH) = VAL(TOKEN$)
      WINNING.LENGTH = WINNING.LENGTH + 1
      GOTO NEXT.TOKEN
FOUND.NUM:
      NUMBERS(NUMBERS.LENGTH) = VAL(TOKEN$)
      NUMBERS.LENGTH = NUMBERS.LENGTH + 1
      GOTO NEXT.TOKEN
NOT.DIGIT:
      IF TOKEN$ = "|" THEN SIDE = RIGHT:GOTO NEXT.TOKEN
EXIT.LOOP:
      DONE = 1
NEXT.TOKEN:
    NEXT DONE

    WINNERS = 0
    FOR GOT = 0 TO NUMBERS.LENGTH - 1
      FOR WIN = 0 TO WINNING.LENGTH - 1
        IF NUMBERS(GOT) = WINNING(WIN) THEN WINNERS = WINNERS + 1
      NEXT WIN
    NEXT GOT

    IF WINNERS = 0 THEN SKIP.PRIZE

    FOR PRIZE = 1 TO WINNERS
      N = CARD.NO + PRIZE: GOSUB APPEND.COUNT
      COUNTS(N) = COUNTS(N) + COUNTS(CARD.NO)
    NEXT PRIZE

SKIP.PRIZE:
  NEXT EOF
  FOR INDEX = 0 TO COUNTS.LENGTH - 1
      TOTAL = TOTAL + COUNTS(INDEX)
  NEXT INDEX

  JIFFIES = TI
  PRINT "TOTAL CARDS:" TOTAL
  PRINT "TIME: ";

  SECONDS = INT(JIFFIES / 60)
  JIFFIES = JIFFIES - SECONDS * 60
  MINUTES = INT(SECONDS / 60)
  SECONDS = SECONDS - MINUTES * 60
  IF MINUTES < 60 THEN SKIP.HOURS
  HOURS = INT(MINUTEs / 60)
  MINUTES = MINUTES - HOURS * 60
  PRINT MID$(STR$(HOURS),2)"H ";
SKIP.HOURS:
  PRINT MID$(STR$(MINUTES),2)"M ";
  PRINT MID$(STR$(SECONDS),2)"S ";
  PRINT MID$(STR$(JIFFIES),2)"J";
  END

APPEND.COUNT:
    IF N < COUNTS.LENGTH THEN SKIP.APPEND:
    COUNTS.LENGTH = COUNTS.LENGTH + 1
    COUNTS(N) = 1
SKIP.APPEND:
    RETURN

SKIP.LABEL:
  INDEX = 1
SKIP.TO.COLON:
  CH$ = MID$(CARD$, INDEX, 1)
  INDEX = INDEX + 1
  IF CH$ <> ":" THEN SKIP.TO.COLON
  RETURN

GET.TOKEN:
  CH$ = MID$(CARD$, INDEX, 1)
  INDEX = INDEX + 1
  IF CH$ = " " THEN GET.TOKEN

  TOKEN$ = CH$

TOKEN.CHARS:
  CH$ = MID$(CARD$, INDEX, 1)
  INDEX = INDEX + 1
  IF CH$ <> " " THEN TOKEN$ = TOKEN$ + CH$
  IF CH$ <> " " AND INDEX <= LEN(CARD$) THEN TOKEN.CHARS

  RETURN