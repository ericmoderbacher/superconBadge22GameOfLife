
;r3 and r4 are the current nibble we are working on
;r5 is the current bit in that nibble

;r6 and r7 are the nibble we are ping ponging into (either 2 pages forward or 2 back)

;oops i ran out of registers lets try again
;r1 and r2 are the current nibble we are working on
;r3 is the current bit in that nibble

;r4 and r5 are the nibble we are ping ponging into (either 2 pages forward or 2 back)

;r6 is the neighbor id we want to check at any given moument

;r7 and r8 are where we will put the calculated nibble address we will find the current neighbor at
;r9 is where we will put the calculated bit address in the nibble pointed to by r7 and r8

;farts i ran out of registers so how about i do it worse!
;r1 and r2 are the current nibble we are working on
;r3 is the current bit in that nibble

; the destination will be calculated on the fly hopefully
;r4 is the neighbor id we want to check at anygiven moment
;r5 and r6 are where we will put the calculated nibble address we will find the current neighbor at
;r7 is where we will put the calculated bit address in the nibble pointed to by r5 and r6

;r8 is the current state of the current pixel
;r9 is the accumulated neighbor score



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

; R3 and R4 are used to keep track of the outermost loop
MOV R1, 0b0001 ;first half of the number 16 00010000
MOV R2, 0b0000 ;second half

main:
;MOV R0,[0xF4] ;hopefullyreads from V flag
MOV R1, 0b0001 ;first half of the number 16 00010000
MOV R2, 0b0000 ;second half
mainSkipingSetup:
MOV R0,[R1:R2] ;moves the value at 8bit address to R0
BTG R0, 0 ;toggles the 1th bit
BTG R0, 1 ;toggles the 4th bit
BTG R0, 2 ;toggles the 4th bit
BTG R0, 3 ;toggles the 4th bit

;BIT RO, 3 ;check new state of that bit sets v flag
MOV [R1:R2],R0
INC R2 ;if result is 0000 then sets z and c
SKIP NZ, 1
INC R1
MOV R0, R1
BIT R0,1
SKIP NZ, 1
MOV R1, 0b0001
GOTO mainSkipingSetup
