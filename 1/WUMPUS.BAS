'$DYNAMIC
DEFINT A-Z
DECLARE SUB Cave.Names.Init (CaveList() AS STRING)


DECLARE SUB Date.Init ()
DECLARE SUB TimeDisplay ()
DECLARE SUB Bar.Title (Text AS STRING, X%, Y%, Length%)
DECLARE SUB Font.Regular (Text$, X%, Y%, col%)
DECLARE SUB Help ()
DECLARE SUB KeyGet ()
DECLARE SUB Wumpus.Draw ()
DECLARE SUB Communicate (X%, Y%, Length%)

DECLARE FUNCTION YesNo% ()

DIM SHARED Key$

DIM SHARED Month$(12)
DIM Cave$(0 TO 6), S(20, 3), L(6), M(6), Piece(5)


Date.Init
CALL Cave.Names.Init(Cave$())

RANDOMIZE TIMER
WIDTH 80
CLS
CALL Communicate(1, 1, 80)
GOSUB Info.General

SelectScreen:
DO
    FOR I = 0 TO 6
        COLOR 15, 0
        LOCATE 23, (I + 1) * 9, 0
        IF A = I THEN PRINT "ÉÍÍÍ»" ELSE PRINT "     "
        LOCATE 24, (I + 1) * 9, 0
        IF A = I THEN PRINT "º"; I; "º"; ELSE PRINT " "; I; " ";
        LOCATE 25, (I + 1) * 9, 0
        IF A = I THEN PRINT "ÈÍÍÍ¼"; ELSE PRINT "     ";
    NEXT I
    COLOR 7, 0
    LOCATE 9, 10, 0
    PRINT "Cave ";
    PRINT USING "#:"; A;
    PRINT Cave$(A) + SPACE$(11)
    ON A + 1 GOSUB 13, 16, 19, 22, 25, 28, 31
    GetKey
    SELECT CASE Key$
        CASE "6"
            A = A + 1
        CASE "4"
            A = A - 1
        CASE "1", "F1"
            CALL Help
        CASE "RET"
            GOTO 67
        CASE "ESC"
            EXIT DO
        CASE ELSE
    END SELECT
    IF A > 6 THEN A = 0 ELSE IF A < 0 THEN A = 6
LOOP

COLOR 7, 0
CLS
END

13 LOCATE 11, 1, 0
PRINT "The rooms of this cave are on a 12-sided object, each forming a pentagon."
LOCATE 12, 1, 0
PRINT "The rooms are at the corners of the pentagons, each room having tunnels  "
LOCATE 13, 1, 0
PRINT "that lead to three other rooms."
RETURN

16 LOCATE 11, 1, 0
PRINT "This cave is two rooms wide and ten rooms around. There is a half twist  "
LOCATE 12, 1, 0
PRINT "somewhere. Two pits placed just right will force a detour back around the"
LOCATE 13, 1, 0
PRINT "strip." + SPACE$(60)
RETURN

19 LOCATE 11, 1, 0
PRINT "The rooms of this cave are laid out like a string of beads, five beads in"
LOCATE 12, 1, 0
PRINT "a circle. Each bead is a diamond with a vertical crossbar. Placement of  "
LOCATE 13, 1, 0
PRINT "the pits can make some places inaccessible except by bat-express."
RETURN

22 LOCATE 11, 1, 0
PRINT "This cave is like a rectangle with 20 points inside, with right and left "
LOCATE 12, 1, 0
PRINT "sides joined to make a cylinder and top and bottom joined to make a      "
LOCATE 13, 1, 0
PRINT "torus." + SPACE$(60)
RETURN

25 LOCATE 11, 1, 0
PRINT "In this cave, some rooms connect to themselves and some caves have more  "
LOCATE 12, 1, 0
PRINT "than one tunnel that leads to another cave. This cave is especially      " + SPACE$(30)
LOCATE 13, 1, 0
PRINT "susceptible to severance by pits"
RETURN

28 LOCATE 11, 1, 0
PRINT "This cave is the extreme example of all tunnels being one-way, the same  "
LOCATE 12, 1, 0
PRINT "way. if you miss the cave you want to go to, you have to travel all the  " + SPACE$(30)
LOCATE 13, 1, 0
PRINT "way back round the cave.        "
RETURN

31 LOCATE 11, 1, 0
PRINT "For this cave the computer will ask you for three destination tunnnels   "
LOCATE 12, 1, 0
PRINT "for each of the 20 rooms in this game. Rooms with tunnels leading to    "
LOCATE 13, 1, 0
PRINT "themselves are allowed.        "
RETURN


67
GOSUB Info.General
LOCATE 2, 1, 0
PRINT "Cave ";
PRINT USING "#:"; A;
PRINT Cave$(A)
GOSUB Info.General
GOSUB 4000
SELECT CASE A
    CASE 0: RESTORE DodecahedronData
    CASE 1: RESTORE MobiusStripData
    CASE 2: RESTORE StringOfBeadsData
    CASE 3: RESTORE ToroidialHexData
    CASE 4: RESTORE DendriteData
    CASE 5: RESTORE LatticeData
    CASE 6: GOTO 76
END SELECT
75 FOR I = 1 TO 20
    FOR J = 1 TO 3
        READ S(I, J)
    NEXT J
NEXT I
GOTO 79
76 FOR I = 1 TO 20
    77 LOCATE 4, 1, 0
    PRINT "Room #"; I;
    INPUT S(I, 1), S(I, 2), S(I, 3)
    FOR J = 1 TO 3
        IF S(I, J) > 0 AND S(I, J) < 21 AND INT(S(I, J)) = ABS(S(I, J)) THEN
            GOTO 78
        ELSE
            LOCATE 5, 1
            PRINT "Error, Try again."
            TIM = TIMER + 1
            WHILE TIM > TIMER
            WEND
            LOCATE 5, 1
            PRINT SPACE$(18)
            GOTO 77
        END IF
    78 NEXT J
    LOCATE 4, 1
    PRINT SPACE$(20)
NEXT I
79 IF A = 6 THEN
    CALL Wumpus.Draw
    FOR I = 4 TO 13
        LOCATE I, 1, 0
        PRINT SPACE$(79)
    NEXT I
END IF
80 FOR I = 1 TO 6
    L(I) = INT(RND(1) * 20) + 1
    M(I) = L(I)
NEXT I
FOR I = 1 TO 6
    FOR J = I + 1 TO 6
        IF L(I) = L(J) THEN
            GOTO 80
        END IF
    NEXT J
NEXT I
AR = 5
W = 0
83 L = L(1)
LOCATE 4, 1
PRINT SPACE$(70)
FOR I = 2 TO 6
    FOR J = 1 TO 3
        IF S(L(1), J) <> L(I) THEN GOTO 88
        ON I - 1 GOTO 85, 86, 86, 87, 87
        85 LOCATE 4, 4
        PRINT "I smell a Wumpus."
        GOTO 88
        86 LOCATE 4, 22
        PRINT "I feel a draft."
        GOTO 88
        87 LOCATE 4, 39
        PRINT "I hear bats in the distance."
    88 NEXT J
NEXT I
LOCATE 5, 1
PRINT "You are in room"; L(1); "... Tunnels lead to"; S(L, 1); S(L, 2); S(L, 3); "  "
90 LOCATE 6, 1
PRINT "Do you wish to <S>hoot or <M>ove:" + SPACE$(10)
DO
    GetKey
    SELECT CASE Key$
        CASE "S"
            GOTO DoShoot
        CASE "M"
            GOTO DoMove
        CASE "ESC"
            GOTO 900
        CASE ELSE
    END SELECT
LOOP

DoShoot:
L = L(1)
LOCATE 6, 1
PRINT SPACE$(33)
LOCATE 6, 1
PRINT "Number of rooms: (1-5)"
GetKey
Z9 = VAL(Key$)
IF Key$ = CHR$(27) THEN GOTO 90
IF Z9 < 1 OR Z9 > 5 THEN
    GOTO DoShoot
ELSE
    PRINT Key$
END IF
FOR I = 1 TO Z9
    98
    LOCATE 7, 1
    PRINT "Room"; I; ":"
    LINE INPUT N$
    Piece(I) = VAL(N$)
    IF N$ = CHR$(27) THEN
        LOCATE 7, 1:
        PRINT SPACE$(80)
        PRINT SPACE$(80)
        GOTO 90
    END IF
    IF Piece(I) < 1 OR Piece(I) > 20 OR INT(Piece(I)) <> ABS(Piece(I)) THEN GOTO 98
    LOCATE 8, 1
    PRINT SPACE$(80)
NEXT I
103 LOCATE 7, 1
PRINT "Are these rooms correct (y/n):";
FOR I = 1 TO Z9
    PRINT Piece(I);
NEXT I
IF NOT YesNo THEN
    LOCATE 7, 1
    PRINT SPACE$(80)
    GOTO DoShoot
END IF
FOR I = 1 TO Z9
    IF S(L, 1) <> Piece(I) AND S(L, 2) <> Piece(I) AND S(L, 3) <> Piece(I) THEN
        L = S(L, INT(RND * 3))
    ELSE
        L = Piece(I)
    END IF
    IF L = L(2) THEN
        LOCATE 6, 1
        PRINT "You shot the Wumpus. He was in room"; L(2)
        GetKey
        GOTO 900
    END IF
    IF L = L(1) THEN
        LOCATE 6, 1
        PRINT "The arrow got you.  "
        GetKey
        GOTO 900
    END IF
NEXT I
AR = AR - 1
IF AR = 0 THEN
    LOCATE 6, 1
    PRINT "You are out of arrows."
    GetKey
    GOTO 900
END IF
W = 1
GOTO 300
DoMove:
LOCATE 7, 1
INPUT "Where do you want to go"; L$
L = VAL(L$)
LOCATE 7, 1
PRINT SPACE$(80)
IF L$ = "" THEN
    GOTO 90
ELSE
    IF S(L(1), 1) <> L AND S(L(1), 2) <> L AND S(L(1), 3) <> L THEN
        GOTO DoMove
    ELSE
        L(1) = L
    END IF
END IF
IF L(1) = L(3) OR L = L(4) THEN
    LOCATE 6, 1
    PRINT "You fell into a pit." + SPACE$(40)
    GetKey
    GOTO 900
END IF
212 IF L(1) = L(5) OR L = L(6) AND L(1) <> L(2) THEN
    LOCATE 6, 1
    PRINT "Super bat snatch"
    PRINT "Elsewheresville for you"
    L(1) = INT(3 * RND) + 1
    GetKey
    GOTO 212
END IF
IF L(1) = L(2) THEN
    LOCATE 6, 1
    PRINT "Silly you, you bumped into the Wumpus.   "
    GetKey
    GOTO 900
END IF

300 MW = INT(4 * RND) + 1
IF MW = 4 OR W <> 1 THEN GOTO 83
L(2) = S(L(2), K)
IF L(1) = L(2) THEN
    LOCATE 6, 1
    PRINT "The wumpus got you."
    GetKey
    GOTO 900
ELSE
    GOTO 83
END IF
MW = INT(4 * RND) + 1
900 LOCATE 6, 1
PRINT "Do you want to reenter the caverns again using the same setup?"
IF YesNo THEN
    LOCATE 6, 1
    PRINT SPACE$(55)
    FOR I = 1 TO 6
        L(I) = M(I)
    NEXT I
    GOSUB 4000
    GOTO 83
END IF

903 LOCATE 6, 1
PRINT "Do you want to use this cavern again?"
GetKey
IF YesNo THEN
    GOSUB 4000
    GOTO 80
ELSE
    FOR I = 2 TO 13
        LOCATE I, 1
        PRINT SPACE$(80)
    NEXT I
    GOSUB Info.General
    GOTO SelectScreen
END IF


3006 LOCATE N, 40 - LEN(A$) / 2
PRINT A$
RETURN


Info.General:
CALL Font.Regular("WUMPUS CAVERNS", 30, 5, 15)
CALL Font.Regular("Press Escape to exit.", 60, 5, 15)
CALL Wumpus.Draw
RETURN


4000 FOR I = 23 TO 25
    LOCATE I, 1, 0
    PRINT SPACE$(79);
NEXT I
FOR I = 3 TO 13
    LOCATE I, 1, 0
    PRINT SPACE$(79)
NEXT I
RETURN

DodecahedronData:
DATA 2,5,8,1,3,10,2,4,12,3,5,14,1,4,6
DATA 5,7,15,6,8,17,1,7,9,8,10,18,2,9,11
DATA 10,12,19,3,11,13,12,14,20,4,13,15,6,4,16
DATA 15,17,20,7,16,18,9,17,19,11,18,20,13,16,19

MobiusStripData:
DATA 20,2,3,19,1,4,1,4,5,2,3,6,3,6,7
DATA 4,5,8,5,8,9,6,7,10,7,10,11,8,9,12
DATA 9,12,13,10,11,14,11,14,15,12,13,16,12,16,17
DATA 14,15,18,15,18,19,16,17,20,2,17,20,1,18,19

StringOfBeadsData:
DATA 2,3,20,1,3,4,1,2,4,2,3,5,4,6,7
DATA 5,7,8,5,6,8,6,7,9,8,10,11,9,11,12
DATA 9,10,12,10,11,13,12,14,15,13,15,16,13,14,16
DATA 14,15,17,16,18,19,17,19,20,17,18,20,1,18,19

ToroidialHexData:
DATA 6,10,16,6,7,17,7,8,18,8,9,19,9,10,20
DATA 1,2,15,2,3,11,3,4,12,4,5,13,5,6,14
DATA 7,16,20,8,16,17,9,17,18,10,18,19,6,19,20
DATA 1,11,12,2,12,13,3,13,14,4,14,15,5,11,15

DendriteData:
DATA 1,1,5,2,2,5,3,3,6,4,4,6,1,2,7
DATA 3,4,7,5,6,10,8,9,9,8,8,10,7,9,11
DATA 10,13,14,12,13,13,11,12,12,11,15,16,14,17,18
DATA 14,19,20,15,17,17,15,18,18,16,19,19,16,20,20

LatticeData:
DATA 5,4,8,1,5,6,2,6,7,3,7,8,8,9,12
DATA 5,9,10,6,10,11,7,11,12,12,13,16,9,13,14
DATA 10,14,15,11,15,16,16,17,20,13,17,18,14,18,19
DATA 15,19,20,1,4,20,1,2,17,2,3,18,3,4,19

SUB Block.Expand
FOR I = 1 TO 11
    FOR J = 13 - I TO 13 + I
        LOCATE J, 20 - I, 0
        IF J = 13 - I THEN
            PRINT "Ú" + STRING$((I + 20) * 2, 196) + "¿";
        ELSE
            IF J = 13 + I THEN
                PRINT "À" + STRING$((I + 20) * 2, 196) + "Ù";
            ELSE
                PRINT "³" + STRING$((I + 20) * 2, 32) + "³";
            END IF
        END IF
    NEXT J
NEXT I
END SUB

SUB Cave.Names.Init (CaveList() AS STRING)
CaveList(0) = "Dodecahedron"
CaveList(1) = "Mobius Strip"
CaveList(2) = "String of Beads"
CaveList(3) = "Toroidial Hex Network"
CaveList(4) = "Dendrite with Degeneracies"
CaveList(5) = "One-Way Lattice"
CaveList(6) = "Your Own Design"
END SUB

SUB Communicate (X, Y, Length)
CALL Bar.Title("Wumpus Caverns", X, Y, Length)
TimeDisplay
END SUB

SUB Help
COLOR 7, 0
FOR I = 1 TO 11
    FOR J = 13 - I TO 13 + I
        LOCATE J, 20 - I, 0
        IF J = 13 - I THEN
            PRINT "Ú" + STRING$((I + 20) * 2, 196) + "¿";
        ELSE
            IF J = 13 + I THEN
                PRINT "À" + STRING$((I + 20) * 2, 196) + "Ù";
            ELSE
                PRINT "³" + STRING$((I + 20) * 2, 32) + "³";
            END IF
        END IF
    NEXT J
NEXT I
LOCATE 3, 11
PRINT "Hazards:"
LOCATE 4, 14
PRINT "Bottomless Pits - Two rooms have bottomless pits in them,"
LOCATE 5, 14
PRINT "If you go into one of the rooms, you will fall into the"
LOCATE 6, 14
PRINT "pit and lose."
LOCATE 8, 14
PRINT "Superbats - Two other rooms have Superbats, sort of a"
LOCATE 9, 14
PRINT "rapid transit system gone batty. They take you to a"
LOCATE 10, 14
PRINT "random cave and leave you there. If that's a pit or a"
LOCATE 11, 14
PRINT "Wumpus, well, you could be staying down here permanently."
LOCATE 13, 11
PRINT "Wumpus:"
LOCATE 14, 14
PRINT "The Wumpus is not bothered by the hazards (He has sucker"
LOCATE 15, 14
PRINT "feet and is too heavy for a bat to lift). He is usually"
LOCATE 16, 14
PRINT "asleep, but if you move into his room or shoot, he will"
LOCATE 17, 14
PRINT "wake and could move. If he moves into your room, he will"
LOCATE 18, 14
PRINT "swallow you whole which means you are dead and you lose."
LOCATE 20, 14
PRINT "Press any key to continue..."
    
DO
    GetKey
    SELECT CASE Key$
        CASE ""
        CASE "ESC": GOTO Help.ResetScreen
        CASE ELSE: EXIT DO
    END SELECT
LOOP

COLOR 7, 0
FOR I = 3 TO 20
    LOCATE I, 11
    PRINT SPACE$(60)
NEXT I
LOCATE 3, 14
PRINT "You have 5 arrows. Each arrow can go a distance of 5"
LOCATE 4, 14
PRINT "rooms. You can shoot an arrow through any rooms you want"
LOCATE 5, 14
PRINT "the arrow to go to. If the arrow can't go that way due to"
LOCATE 6, 14
PRINT "the tunnel not being there the computer will randomly send"
LOCATE 7, 14
PRINT "an arrowto the next room. If you run out of arrows without"
LOCATE 8, 14
PRINT "killing the Wumpus, you lose. If the arrow hits you, you"
LOCATE 9, 14
PRINT "lose. If the arrow hits the Wumpus, you win."
LOCATE 11, 11
PRINT "Warnings:"
LOCATE 12, 14
PRINT "When you are one room away from the Wumpus or a Hazard"
LOCATE 13, 14
PRINT "you will be able to tell by one of these"
LOCATE 14, 14
PRINT "messages:"
LOCATE 16, 14
PRINT "Wumpus: I smell a Wumpus."
LOCATE 17, 14
PRINT "Pits: I feel a draft."
LOCATE 17, 14
PRINT "Superbats: I hear bats in the distance."
LOCATE 20, 14
PRINT "Press any key to continue..."
DO
    GetKey
    SELECT CASE Key$
        CASE ""
        CASE ELSE
            EXIT DO
    END SELECT
LOOP
EXIT SUB
Help.ResetScreen:
COLOR 7, 0
FOR I = 2 TO 24
    LOCATE I, 9
    PRINT SPACE$(64);
NEXT I
'GOSUB Info.General
Key$ = ""
END SUB

SUB Wumpus.Draw
LOCATE 14, 35, 0: PRINT "^^^^^^^^^^^"
LOCATE 15, 32, 0: PRINT "^^^ ÉÍÄÄÄÂÄÄÄÍ»"
LOCATE 16, 31, 0: PRINT "^  /Ú½ /^\|/^\ Ó¿\"
LOCATE 17, 30, 0: PRINT "^ÚÄÁÄ´   ~   ~   ÃÄÁÄ¿"
LOCATE 18, 30, 0: PRINT "^³  ÚÁÄÄÄÄÄÄÄÄÄÄÄÁ¿  ³"
LOCATE 19, 30, 0: PRINT "^³ÕÍ³|ÛþßþÜþßþÜþÛ|³Í¸³"
LOCATE 20, 30, 0: PRINT "^Æµ ÀÄÄÅÄÄÄÄÄÄÄÄÄÄÙ Æµ"
LOCATE 21, 30, 0: PRINT "^éé    î            éé"
LOCATE 22, 40, 0: PRINT "Wumpus:"
END SUB

SUB Date.Init
Month$(1) = "Jan"
Month$(2) = "Feb"
Month$(3) = "Mar"
Month$(4) = "Apr"
Month$(5) = "May"
Month$(6) = "Jun"
Month$(7) = "Jul"
Month$(8) = "Aug"
Month$(9) = "Sep"
Month$(10) = "Oct"
Month$(11) = "Nov"
Month$(12) = "Dec"
END SUB

SUB stdwai STATIC
'Stuff to do while awaiting input
TimeDisplay

END SUB

SUB GetKey STATIC
Key$ = ""
WHILE Key$ = ""
    Key$ = INKEY$
    CALL stdwai
WEND
kbd = ASC(RIGHT$(Key$, 1)): IF LEN(Key$) = 2 THEN GOTO nd
IF kbd > 96 AND kbd < 123 THEN Key$ = CHR$(kbd - 32)
IF kbd = 27 THEN Key$ = "ESC"
IF kbd = 13 THEN Key$ = "RET"
EXIT SUB

nd:
IF kbd > 58 AND kbd < 69 THEN Key$ = "F" + RIGHT$(STR$(kbd - 58), 1)
IF kbd > 132 AND kbd < 135 THEN Key$ = "F" + RIGHT$(STR$(kbd - 132), 1)
IF kbd > 70 AND kbd < 74 THEN Key$ = CHR$(kbd - 16)
IF kbd > 74 AND kbd < 78 THEN Key$ = CHR$(kbd - 23)
IF kbd > 78 AND kbd < 82 THEN Key$ = CHR$(kbd - 30)
'PRINT KBD,Key$
END SUB

SUB Font.Regular (Text$, X, Y, ForeColor)
LOCATE Y, X, 0
COLOR ForeColor
PRINT Text$;
END SUB

SUB Bar.Title (Text AS STRING, X, Y, Length) STATIC
COLOR 14, 1
FOR I = 1 TO 3
    LOCATE I, 1
    PRINT STRING$(80, 32)
NEXT I
RX1 = 1
RX2 = 40
'CALL Center(Title$, RX1, RX2)
LOCATE 1, 1
PRINT "Help F1";
LOCATE 2, 2
DECLARE SUB TimeDisplay ()
END SUB

SUB TimeDisplay STATIC
52 HOUR = VAL(LEFT$(TIME$, 2)): IF HOUR > 12 THEN MER$ = "pm" ELSE MER$ = "am"
53 IF HOUR > 12 THEN HOUR = HOUR - 12 ELSE IF HOUR = 0 THEN HOUR = 12
54 COLOR 14, 1
LOCATE 1, 71
PRINT STR$(HOUR); MID$(TIME$, 3, 3); " "; MER$;
57 LOCATE 1, 10
PRINT Month$(VAL(LEFT$(DATE$, 2))); STR$(VAL(MID$(DATE$, 4, 2))); ", "; RIGHT$(DATE$, 4);
END SUB
