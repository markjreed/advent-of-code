#CONTROLCODES 1
#SYMFILE "@2:day13.sym"
Debugging = 0
CrsrLeft = ASC("{LEFT}")
CrsrUp$  = "{UP}"
Space    = ASC(" ")
Period   = ASC(".")
LineFeed = 10
Infinity = VAL("1.70141183E38")
Lose$    = "lose"

DefaultFile$ = "SAMPLE.TXT"

CLS

GetFile:
    PRINT "INPUT FILENAME: " DefaultFile$ RPT$(CrsrLeft, LEN(DefaultFile$));
    LINPUT File$

    OPEN 1, 8, 2, File$
    OPEN 15, 8, 15
    INPUT# 15, DiskStatus, Messasge$, Track, Sector
    CLOSE 15
    IF DiskStatus THEN CLOSE 1:PRINT Message$: PRINT: GOTO GetFile

    StartTime = TI
    MaxGuests = 0
FirstPass:
    LINPUT#1, Rule$, LineFeed
    IF ST AND 64 THEN FirstDone
    MaxGuests = MaxGuests + 2
    Goto FirstPass

FirstDone:
    CLOSE 1

    DIM GuestName$(MaxGuests - 1)
    DIM Score%(MaxGuests - 1, MaxGuests - 1)
    GuestCount = 0

    OPEN 1, 8, 2, File$

SecondPass:
    LINPUT#1, Guest1$, Space
    IF Debugging THEN Ascii$ = Guest1$: GOSUB MakePetscii: Guest1$ = Petscii$
    IF ST AND 64 THEN Done
    IF GuestCount = 0 THEN AddGuest
    FOR I = 0 TO GuestCount - 1
        IF GuestName$(I) = Guest1$ THEN Guest1 = I: GOTO GotGuest1
    NEXT I

AddGuest:
    GuestName$(GuestCount) = Guest1$
    Guest1 = GuestCount
    GuestCount = GuestCount + 1

GotGuest1:
    LINPUT#1, X$, Space: REM Skip "would"
    LINPUT#1, Dir$, Space
    LINPUT#1, Points$, Space
    FOR I = 1 TO 6: LINPUT#1, X$, Space: NEXT I: REM skip to second guest name
    LINPUT#1, Guest2$, Period
    IF Debugging THEN Ascii$ = Guest2$: GOSUB MakePetscii: Guest2$ = Petscii$
    GET#1, X$: REM Skip linefeed

    FOR I = 0 TO GuestCount - 1
        IF GuestName$(I) = Guest2$ THEN Guest2 = I: GOTO GotGuest2
    NEXT I

    GuestName$(GuestCount) = Guest2$
    Guest2 = GuestCount
    GuestCount = GuestCount + 1

GotGuest2:
    Points = VAL(Points$)
    IF Dir$ = Lose$ THEN Points = -Points
    Score%(Guest1, Guest2) = Points

    GOTO SecondPass

Done:
    CLOSE 1

DIM Arrangement%(GuestCount)
Part = 1
NextPart:
    PRINT "PART" Part " -";
    GuestCount = GuestCount + Part - 1
    PermCount = 1
    FOR I = 1 TO GuestCount - 1:
        PermCount = PermCount * I
    NEXT I
    PRINT GuestCount "GUESTS, MAKING" PermCount "POSSIBLE SEATING ARRANGEMENTS."

    FOR I = 0 TO GuestCount - 1
        Arrangement%(I) = I
    NEXT I

PermsLoop:
    BestScore = -Infinity
    FOR PermNum = 0 TO PermCount - 1
        PRINT PermNum; CrsrUp$
        TotalScore = 0
        FOR I = 0 TO GuestCount - 2
            Guest1 = Arrangement%(I)
            Guest2 = Arrangement%(I + 1)
            TotalScore = TotalScore + Score%(Guest1, Guest2) 
            TotalScore = TotalScore + Score%(Guest2, Guest1)
        NEXT I
        TotalScore = TotalScore + Score%(Guest2, Arrangement%(0))
        TotalScore = TotalScore + Score%(Arrangement%(0), Guest2)

        IF TotalScore > BestScore THEN BestScore = TotalScore
        GOSUB NextPerm
    NEXT PermNum
    PRINT "BEST SCORE:" BestScore
    PART = PART + 1
    IF PART < 3 THEN NextPart

PRINT "COMPUTED IN" (TI - StartTime) "JIFFIES."
END


MakePetscii:
    REM For help with debugging, this translates the names from the input
    REM file from ASCII to PETSCII so they look like "ALICE" and "BOB"
    REM instead of "A┗╮━─" and "B┌┃".
    Petscii$ = ""
    FOR MakePetscii.I = 1 TO LEN(Ascii$)
        CharCode = ASC(MID$(Ascii$, MakePetscii.I))
        IF CharCode > 96 AND CharCode < 128 THEN CharCode = CharCode - 32
        Petscii$ = Petscii$ + CHR$(CharCode AND 127)
    NEXT MakePetscii.I
    RETURN
        
NextPerm:   
    REM Advance to the next circularly-unique permutation of guests
    REM (which we do by keeping the first position unchanged and 
    REM  advancing to the lexically next permutation of the rest of the list)

    REM First, find the pivot point: highest index I such that
    REM Arrangment%(I) < Arrangement%(I+1)
    Pivot = GuestCount - 2

FindPivot:
    IF Arrangement%(Pivot) < Arrangement%(Pivot + 1) THEN FoundPivot
    Pivot = Pivot - 1
    IF Pivot >= 1 THEN FindPivot
    RETURN

FoundPivot:
    Right = GuestCount - 1

    REM Now find the location to the right of the pivot whose value should
    REM replace it: 
    REM the higest index J such that Arrangement%(J) > Arrangement%(I)
FindRight:
    IF Arrangement%(Right) > Arrangement%(Pivot) THEN FoundRight
    Right = Right - 1
    GOTO FindRight

FoundRight:
    REM Swap the values at the pivot and right indexes
    Temp% = Arrangement%(Pivot)
    Arrangement%(Pivot) = Arrangement%(Right)
    Arrangement%(Right) = Temp%


    REM Now reverse the list to the right of the pivot
    TailLength = GuestCount - 1 - Pivot
    FOR Delta = 0 TO INT(TailLength / 2) - 1
        Left  = Pivot + 1 + Delta
        Right = GuestCount - 1 - Delta
        Temp% = Arrangement%(Left)
        Arrangement%(Left) = Arrangement%(Right)
        Arrangement%(Right) = Temp%
    NEXT Delta

    RETURN

PrintPerm:
    PRINT GuestName$(Arrangement%(0));
    FOR I = 1 TO GuestCount - 1
        PRINT ", " GuestName$(Arrangement%(I));
    NEXT I
    PRINT
    RETURN
