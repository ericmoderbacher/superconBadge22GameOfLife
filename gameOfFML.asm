;maybe this:
;r0 reserved for working
;r1 and 2 are the pointer to the nible im currently working on in the functions that do stuff with nibbles
;r3 is the bit number of the bit im working on in that nibble for functions
;r4 is row of current cell we are working
;r5 is col of the current cell we are working
;r6 is the current neighbor row
;r7 is the current neighbor col
;r8 is the neighbor count






;Need to set the glider on page 2
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

; R1 and R2 are used to keep track of the outermost loop
MOV R1, 0b0001 ;first half of the number 16 00010000
MOV R2, 0b0000 ;second half
MOV R3, 0 ;the current bit in that nibble

main:
MOV R1, 0b0001 ;first half of the number 16 00010000
MOV R2, 0b0000 ;second half
mainSkipingSetup: ;outer loop (the current nibble of the matrix) begin
MOV R0, [R1:R2] ;moves the value at 8bit address to R0
;BTG R0, 0 ;toggles the 1th bit
;BTG R0, 1 ;toggles the 4th bit
;BTG R0, 2 ;toggles the 4th bit
;BTG R0, 3 ;toggles the 4th bit
bitLoop:

;calls the function that does the logic for each cell expects r1-r3 to be set up
GOTO theCellFunction
theCellFunctionReturnPoint:

inc R3
MOV R0,R3
CP R0, 0b0101 ; is R3 == 5? ;if r0 == n then set z flag
SKIP Z,1
GOTO bitLoop ;done?
MOV R3, 0 ;all of the bits in the current nibble have been worked so we can reset
;at this point we have worked all the cell in this nibble

;BIT RO, 3 ;check new state of that bit sets v flag
MOV [R1:R2],R0
INC R2 ;if result is 0000 then sets z and c
SKIP NZ, 1
INC R1
MOV R0, R1
BIT R0,1 ;if tested bit is 0 then set z flag
SKIP NZ, 1
MOV R1, 0b0001
GOTO mainSkipingSetup ;outer loop (the current nibble of the matrix) end



;The function is the point in our nested loops where we know the nibble and the bit we want to work on
theCellFunction:
//get the living/dead state of the current cell
GOSUB isDead
CP R0,0 ;if r0 == n then set z flag
SKIP Z
goto livingLogic
goto deadlogic
livingLogicReturnPoint:
deadLogicReturnPoint:
GOTO theCellFunctionReturnPoint

;expects r0 to have nible to be checked in it
getValueOfCellzero:
MOV R0, [R1:R2] //get the current nibble
BIT R0,0 ;if tested bit is 0 then set z flag
SKIP Z,1
ret 0
ret 1
getValueOfCellone:
MOV R0, [R1:R2] //get the current nibble
BIT R0,1 ;if tested bit is 0 then set z flag
SKIP Z,1
ret 0
ret 1
getValueOfCelltwo:
MOV R0, [R1:R2] //get the current nibble
BIT R0,2 ;if tested bit is 0 then set z flag
SKIP Z,1
ret 0
ret 1
getValueOfCellthree:
MOV R0, [R1:R2] //get the current nibble
BIT R0,3 ;if tested bit is 0 then set z flag
SKIP Z,1
ret 0
ret 1

killCellzero:
MOV R0, [R1:R2] //get the current nibble
BCLR R0,0 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
ret 1
killCellone:
MOV R0, [R1:R2] //get the current nibble
BCLR R0,1 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
ret 1
killCelltwo:
MOV R0, [R1:R2] //get the current nibble
BCLR R0,2 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
ret 1
killCellthree:
MOV R0, [R1:R2] //get the current nibble
BCLR R0,3 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
ret 1
unkillCellzero:
MOV R0, [R1:R2] //get the current nibble
BCLR R0,0 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
ret 1
unkillCellone:
MOV R0, [R1:R2] //get the current nibble
BCLR R0,1 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
ret 1
unkillCelltwo:
MOV R0, [R1:R2] //get the current nibble
BCLR R0,2 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
ret 1
unkillCellthree:
MOV R0, [R1:R2] //get the current nibble
BCLR R0,3 ;if tested bit is 0 then set z flag
MOV [R1:R2],R0
ret 1

;checks if the current location is dead
isDead:
MOV R0,R3
CP R0,0 ;if r0 == n then set z flag
SKIP NZ,
GOSUB getValueOfCellone
CP R0,0 ;if r0 == n then set z flag
SKIP NZ
GOTO isDeadRet


CP R0

isdeadRet:
ret 1
ret 0

killCell:

ret 0

resuscitateCell:

ret 0

setWorkingPointerToCurentCell:
ret0

;currentNeighbor number must be in r7
setWorkingPointerToCurrentNeighbor:
;012
;3X5
;678

ret0

