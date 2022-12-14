;http://cloud.wd5gnr.com/badgeasm/
;What each register is for:
;r0 reserved for working
;r1 and 2 are the pointer to the nible im currently working on in the functions that do stuff with nibbles
;r3 is the bit number of the bit im working on in that nibble for functions
;r4 is row of current cell we are working
;r5 is col of the current cell we are working
;r6 is the current neighbor row offset index
;r7 is the current neighbor col offset index
;r8 is current alive status
;r9 is the neighbor count

;012
;345
;678

;draw glider on page 2
MOV R4,0b0100 ;glider line 1
MOV R5,0b0010 ;glider line 2
MOV R6,0b1110 ;glider line 3
MOV R0,R4
MOV [25],R0
MOV R0,R5
MOV [26],R0
MOV R0,R6
MOV [27],R0

;set the brightness to save power
MOV R0,0b0111
MOV [0xFE],R0
;set to page 2 (one of the two we will flip between
MOV R0,0b0001 ; set page to view page (R0)
MOV [0xF0],R0   ;esm the bracket seems to be a literal
;slow down the clock
MOV R0,6
MOV [0xF1],R0

main:
MOV R4, 0b0000 ;set row index to zero
MOV R5, 0b0000 ;set col index to zero
MOV R6, 0b0000 ;set the neighbor index to zero

;outermost loop basically main
RowLoop:
ColLoop:
;GOSUB setPointerToCurrentCell
;;GOSUB getValueOfCell
MOV R8,R0 ;set R8 to the status of the current cell
NeighborRowLoop:
NeighborColLoop:

;GOSUB setPointerToCurrentNeighbor ;sets r1,r2,r3 which are needed for cell interaction functions
;GOSUB getValueOfCell ;assumes r1,r2 and r3 are primed for neighbor checking
ADD R9,R0 ;adds current neighbor status to accumulation

INC R7 ;neighbor col index

;if neighbor col index is 1 we need to inc again BEGIN
MOV R0, R7
CP R0, 1 ;if 1 we want to skip again
SKIP NZ,1
INC R7
;if neighbor col index is 1 we need to inc again END

;if neighbor col index is 3 we can continue BEGIN
;MOV R0, R6 ;redundant removed
CP R0, 3 ;if 4 sets z
SKIP NZ,2 ;if neighbor index is 3 now we end this loop otherwise loop
MOV R7, 0 ;reset neighbor col index
GOTO NeighborColLoopEND ;basically 'skip 1 more'
GOTO NeighborColLoop
NeighborColLoopEND:

INC R6 ;neighbor row index

;if neighbor row index is 1 we need to inc again BEGIN
MOV R0, R6
CP R0, 1 ;if 1 we want to skip again
SKIP NZ,1
INC R6
;if neighbor row index is 1 we need to inc again END

;if neighbor row index is 3 we can continue BEGIN
;MOV R0, R6 ;redundant removed
CP R0, 3 ;if 4 sets z
SKIP NZ,2 ;if neighbor index is 9 now we end this loop otherwise loop
MOV R6, 0 ;reset neighbor row index
GOTO NeighborRowLoopEND ;basically 'skip 1 more'
GOTO NeighborRowLoop
NeighborRowLoopEND:

INC R5 ;col index

MOV R0,R5
CP R0,8 ;z if 8
SKIP NZ,2
MOV R5,0 ;reset col index
GOTO ColLoopEND ;basically 'skip 1 more'
GOTO ColLoop
ColLoopEND:

INC R4 ;row index
MOV R0,R4
CP R0,8 ;z if 8
SKIP NZ,2
MOV R4,0 ;reset col index
GOTO RowLoopEND ;basically 'skip 1 more'
GOTO RowLoop ;end of main control loop
RowLoopEND:
GOTO main ;where i would go to the other one


;FUNCTIONS BEGIN:
setPointerToCurrentCell:
;using R4 (current row), R5 (Current Col) populate R1:R2(nibble address) and R3 Bit ID
MOV R2,R4 ;R4 is alread identical to what R2 needs to be

MOV R0,R5
CP R0,4 ;if R5 (current col) is less than or equal to 4 then R1 is 0000 otherwise 0001
MOV R1,0b0000
SKIP NC,1
MOV R1,0b0001

ADD R0,4 ;subtract 4 from r0 which is still set to R5
ADD R0,8 ;thats like subtracting right?
MOV R3,R0 ;That should be right todo validate

RET R0,1


setPointerToCurrentNeighbor:
;using R4 (current row), R5 (Current Col) populate R1:R2(nibble address) and R3 Bit ID
;but this time also using R6 (neighbor row id) and R7 (neighbor col id)
MOV R1,R6
Mov R2,R7

ADD R1,R4
ADD R2,R5


;ADD R1,7
;ADD R2,7 ;modular math i think so at this point r1 is pointed to
MOV R0,R1
ADD R0,7
MOV R1,R0

MOV R0,R2
ADD R0,7
MOV R2,R0


MOV R0,R7
ADD R0,4 ;subtract 4 from r0 which
ADD R0,8 ;thats like subtracting right?
MOV R3,R0 ;That should be right todo validate

RET R0,1




;checks if cell is alive and the accumulation values then decides its fate
theCellFunction:

;checks if the current location is dead
getValueOfCell:
MOV R0,R3

CP R0,0 ;if r0 == n then set z flag
SKIP NZ,1 ;todo change from 0 to the correct value
GOTO getValueOfCellzero

CP R0,1 ;if r0 == n then set z flag
SKIP NZ,1 ;todo change from 0 to the correct value
GOTO getValueOfCellOne

CP R0,2 ;if r0 == n then set z flag
SKIP NZ,1 ;todo change from 0 to the correct value
GOTO getValueOfCellTWO

CP R0,3 ;if r0 == n then set z flag
SKIP NZ,1 ;todo change from 0 to the correct value
GOTO getValueOfCellThree

haveValue:
;next 4 lines is just to return the value of r0
CP R0,1
SKIP NZ, 1
RET R0,1
RET R0,0
;expects r0 to have nible to be checked in it
getValueOfCellzero:
MOV R0, [R1:R2] ;get the current nibble
BIT R0,0 ;if tested bit is 0 then set z flag
SKIP Z,1
RET R0,0
RET R0,1
getValueOfCellone:
MOV R0, [R1:R2] ;get the current nibble
BIT R0,1 ;if tested bit is 0 then set z flag
SKIP Z,1
RET R0,0
RET R0,1
getValueOfCelltwo:
MOV R0, [R1:R2] ;get the current nibble
BIT R0,2 ;if tested bit is 0 then set z flag
SKIP Z,1
RET R0,0
RET R0,1
getValueOfCellthree:
MOV R0, [R1:R2] ;get the current nibble
BIT R0,3 ;if tested bit is 0 then set z flag
SKIP Z,1
RET R0,0
RET R0,1

killCell:
MOV R0,R3

CP R0,0 ;if r0 == n then set z flag
SKIP NZ,2 ;todo change from 0 to the correct value
GOTO killCellzero

CP R0,1 ;if r0 == n then set z flag
SKIP NZ,2 ;todo change from 0 to the correct value
GOTO killCellOne

CP R0,2 ;if r0 == n then set z flag
SKIP NZ,2 ;todo change from 0 to the correct value
GOTO killCellTWO

CP R0,3 ;if r0 == n then set z flag
SKIP NZ,2 ;todo change from 0 to the correct value
GOTO killCellThree

killCellzero:
MOV R0, [R1:R2] ;get the current nibble
BCLR R0,0 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
RET R0,1
killCellone:
MOV R0, [R1:R2] ;get the current nibble
BCLR R0,1 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
RET R0,1
killCelltwo:
MOV R0, [R1:R2] ;get the current nibble
BCLR R0,2 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
RET R0,1
killCellthree:
MOV R0, [R1:R2] ;get the current nibble
BCLR R0,3 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
RET R0,1

unkillCell:
MOV R0,R3

CP R0,0 ;if r0 == n then set z flag
SKIP NZ,2 ;todo change from 0 to the correct value
GOTO unkillCellzero

CP R0,1 ;if r0 == n then set z flag
SKIP NZ,2 ;todo change from 0 to the correct value
GOTO unkillCellOne

CP R0,2 ;if r0 == n then set z flag
SKIP NZ,2 ;todo change from 0 to the correct value
GOTO unkillCellTWO

CP R0,3 ;if r0 == n then set z flag
SKIP NZ,2 ;todo change from 0 to the correct value
GOTO unkillCellThree

unkillCellzero:
MOV R0, [R1:R2] ;get the current nibble
BCLR R0,0 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
RET R0,1
unkillCellone:
MOV R0, [R1:R2] ;get the current nibble
BCLR R0,1 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
RET R0,1
unkillCelltwo:
MOV R0, [R1:R2] ;get the current nibble
BCLR R0,2 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
RET R0,1
unkillCellthree:
MOV R0, [R1:R2] ;get the current nibble
BCLR R0,3 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
RET R0,1


toggleCell:
MOV R0,R3

CP R0,0 ;if r0 == n then set z flag
SKIP NZ,2 ;todo change from 0 to the correct value
GOTO toggleCellzero

CP R0,1 ;if r0 == n then set z flag
SKIP NZ,2 ;todo change from 0 to the correct value
GOTO toggleCellOne

CP R0,2 ;if r0 == n then set z flag
SKIP NZ,2 ;todo change from 0 to the correct value
GOTO toggleCellTWO

CP R0,3 ;if r0 == n then set z flag
SKIP NZ,2 ;todo change from 0 to the correct value
GOTO toggleCellThree

toggleCellzero:
MOV R0, [R1:R2] ;get the current nibble
BTG R0,0 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
RET R0,1
toggleCellone:
MOV R0, [R1:R2] ;get the current nibble
BTG R0,1 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
RET R0,1
toggleCelltwo:
MOV R0, [R1:R2] ;get the current nibble
BTG R0,2 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
RET R0,1
toggleCellthree:
MOV R0, [R1:R2] ;get the current nibble
BTG R0,3 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
RET R0,1





