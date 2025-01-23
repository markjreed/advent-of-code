#CONTROLCODES 1
#SYMFILE "@0:day13.sym"

CrsrLeft = ASC("{LEFT}")
DefaultFile$ = "INPUT.TXT"

CLS
PRINT "INPUT FILENAME: " DefaultFile$ RPT$(CrsrLeft, LEN(DefaultFile$));
LINPUT File$



