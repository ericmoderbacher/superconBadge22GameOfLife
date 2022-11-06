
;glider:
;00010000 ;hex 10; dec 16
;00001000 ;hex 8 ; dec 8
;00111000 ;hex 38; dec 56
gliderLine0 EQU 16
gliderLine1 EQU 8
gliderLine2 EQU 56

;Need to set the glider on page 2
MOV R4,0b0100
MOV R5,0b0010
MOV R6,0b1110
MOV R0,R4
MOV [25],R0
MOV R0,R5
MOV [26],R0
MOV R0,R6
MOV [27],R0

MOV R0,0b0111
MOV [0xFE],R0
MOV R0,0b0001 ; set page to view page (R0)
MOV [0xF0],R0   ;esm the bracket seems to be a literal
MOV R0,6 ; slow it down a little
MOV [0xF1],R0

;Need to set the glider on page 2
MOV R4,0b0100
MOV R5,0b0010
MOV R6,0b1110
MOV R0,R4
MOV [25],R0
MOV R0,R5
MOV [26],R0
MOV R0,R6
MOV [27],R0

MOV R3, 0b0001 ;first half of the number 16 00010000
MOV R4, 0b0000 ;second half

; note on page 1 starts at 16 and the last row should be 31

main:
;MOV R0,[0xF4] ;hopefullyreads from V flag
MOV R3, 0b0001 ;first half of the number 16 00010000
MOV R4, 0b0000 ;second half
mainSkipingSetup:
MOV R0,[R3:R4] ;moves the value at 8bit address to R0
BTG R0, 0 ;toggles the 1th bit
BTG R0, 1 ;toggles the 4th bit
BTG R0, 2 ;toggles the 4th bit
BTG R0, 3 ;toggles the 4th bit

;BIT RO, 3 ;check new state of that bit sets v flag
MOV [R3:R4],R0
INC R4 ;if result is 0000 then sets z and c
SKIP NZ, 1
INC R3
MOV R2, R3
BIT R2,1
SKIP NZ, 1
MOV R3, 0b0001
GOTO mainSkipingSetup
