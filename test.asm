;r1 and r2 are the current nibble we are working on
;r3 is the current bit in that nibble

; the destination will be calculated on the fly hopefully
;r4 is the neighbor id we want to check at anygiven moment
;r5 and r6 are where we will put the calculated nibble address we will find the current neighbor at
;r7 is where we will put the calculated bit address in the nibble pointed to by r5 and r6

;r8 is the current state of the current pixel
;r9 is the accumulated neighbor score (and before that the living or dead status)

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
GOTO theCellFunction
theCellFunctionReturnPoint:
inc R3
MOV R0,R3
CP R0, 0b0101 ; is R3 == 5?
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
BIT R0,1
SKIP NZ, 1
MOV R1, 0b0001
GOTO mainSkipingSetup ;outer loop (the current nibble of the matrix) end

;The function is the point in our nested loops where we know the nibble and the bit we want to work on
theCellFunction:
MOV R9,0
;at this point the accumulation nibble is not being used
MOV R0,R3 ;move the current bit count to r0
CP R0, 0 ;check if current bit in nibble is 0
SKIP NZ,0 ;if not move on 4 steps ahead
MOV R0, [R1:R2]
BIT R0,0
SKIP Z,1
MOV R9,1 ;only hit by skip for lines up! ugh!


MOV R0,R3 ;move the current bit count to r0
CP R0, 1 ;check if current bit in nibble is 0
SKIP NZ,0 ;if not move on 4 steps ahead
MOV R0, [R1:R2]
BIT R0,0
SKIP Z,1
MOV R9,1 ;only hit by skip for lines up! ugh!

MOV R0,R3 ;move the current bit count to r0
CP R0, 2 ;check if current bit in nibble is 0
SKIP NZ,0 ;if not move on 4 steps ahead
MOV R0, [R1:R2]
BIT R0,0
SKIP Z,1
MOV R9,1 ;only hit by skip for lines up! ugh!

MOV R0,R3 ;move the current bit count to r0
CP R0, 3 ;check if current bit in nibble is 0
SKIP NZ,0 ;if not move on 4 steps ahead
MOV R0, [R1:R2]
BIT R0,0
SKIP Z,1
MOV R9,1 ;only hit by skip for lines up! ugh!

;so at this point we should know if we are alive or not!
MOV R0,R9
CP R0,0
SKIP Z,1
GOTO deadcellLogic
GOTO livingCellLogic

deadCellLogicReturnPoint:
livingCellLogicReturnPoint:
GOTO theCellFunctionReturnPoint


deadCellLogic:
MOV R0, [R1:R2] ;moves the value at 8bit address to R0
BTG R0, 0 ;toggles the 1th bit
MOV [R1:R2], R0



goto deadCellLogicReturnPoint

livingCellLogic:
MOV R0, [R1:R2] ;moves the value at 8bit address to R0
BTG R0, 0 ;toggles the 1th bit
MOV [R1:R2], R0

goto livingCellLogicReturnPoint
