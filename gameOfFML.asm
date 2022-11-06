;What each register is for:
;r0 reserved for working
;r1 and 2 are the pointer to the nible im currently working on in the functions that do stuff with nibbles
;r3 is the bit number of the bit im working on in that nibble for functions
;r4 is row of current cell we are working
;r5 is col of the current cell we are working
;r6 is the current neighbor index
;r7 is the neighbor count

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


MOV R4, 0b0000 ;set row index to zero
MOV R5, 0b0000 ;set col index to zero
MOV R6, 0b0000 ;set the neighbor index to zero

;outermost loop basically main
RowLoop:
ColLoop:
GOSUB setPointerToCurrentCell
GOSUB theCellFunction ;todo implement this which sets the output cell!
NeighborIDLoop:

GOSUB setPointerToCurrentNeighbor ;sets r1,r2,r3 which are needed for cell interaction functions
GOSUB NeighborAccumulate ;assumes r1,r2 and r3 are primed for neighbor checking

INC R6 ;neighbor index

;if neighbor index is 4 we need to inc again BEGIN
MOV R0, R6
CP R0, 4 ;if 4 sets z
SKIP NZ,1
INC R6
;if neighbor index is 4 we need to inc again END

;if neighbor index is 9 we can continue BEGIN
;MOV R0, R6 ;redundant removed
CP R0, 9 ;if 4 sets z
SKIP NZ,2 ;if neighbor index is 9 now we end this loop otherwise loop
MOV R6, 0 ;reset neighbor index
GOTO NeighborIDLoopEND ;basically 'skip 1 more'
GOTO NeighborIDLoop
NeighborIDLoopEND:

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
GOTO RowLoop ;where i would go to the other one


;FUNCTIONS BEGIN:
setPointerToCurrentCell:
;using R4 (current row), R5 (Current Col) populate R1:R2(nibble address) and R3 Bit ID
RET R0,1


setWorkingPointerToCurrentNeighbor:
;using R4 (current row), R5 (Current Col) populate R1:R2(nibble address) and R3 Bit ID
;but this time also using R6 (neighbor id)

RET R0,1


;this function sets r1 and r2 to the nibble of the current neighbor
;it also sets r3 to the bit number of the current neighbor
;after this function has ran the cell interaction functions will operate on the current neighbor
setPointerToCurrentNeighbor:

RET R0,0

;this function assumes that setPointerToCurrentNeighbor has just ran
;which means r1 r2 and r3 are ready and pointing at the neighbor
NeighborAccumulate:

RET R0,0







;checks if cell is alive and the accumulation values then decides its fate
theCellFunction:

;todo move parrent overload here
;expects r0 to have nible to be checked in it
getValueOfCellzero:
MOV R0, [R1:R2] ;get the current nibble
BIT R0,0 ;if tested bit is 0 then set z flag
SKIP Z,1
RET R0,0
ret R0,1
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

;todo put parrent overload here
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

;todo put parrent overload here
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

;checks if the current location is dead
getValueOfCell:
MOV R0,R3
CP R0,0 ;if r0 == n then set z flag
SKIP NZ,0 ;todo change from 0 to the correct value
GOSUB getValueOfCellone
CP R0,0 ;if r0 == n then set z flag
SKIP NZ,0 ;todo change from 0 to the correct value
GOTO isDeadRet


;CP R0 ;;esm todo complete

isdeadRet:
RET R0,1
RET R0,0




