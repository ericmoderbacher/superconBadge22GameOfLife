
;glider:
;00010000 ;hex 10; dec 16
;00001000 ;hex 8 ; dec 8
;00111000 ;hex 38; dec 56
gliderLine0 EQU 16
gliderLine1 EQU 8
gliderLine2 EQU 56

; Example program -- replace with your own
max EQU 15
min EQU 0

;Setup
;MOV R8,2 ;Page
MOV R8,1
MOV R2,0b0001 ;Direction
MOV R1,min ;Location
MOV R3,min ; last location
MOV R0,R8 ; set page to view page (R0)
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
MOV R0,[R3:R4]
BTG R0, 3 ;toggles the 4th bit
;BIT RO, 3 ;check new state of that bit sets v flag
MOV [R3:R4],R0
INC R4 ;if result is 0000 then sets z and c
;00 c
;01 nc
;10 z
;11 nz

;00 4
;01 1
;10 2
;11 3
;SKIP 0B1101  ;if not z 11 then skip forward 1
SKIP NZ,0b10
INC R3
SKIP NZ,0b01
GOTO mainSkipingSetup

GOTO main

oldMain:
;Check Location Min/Max & Switch
MOV R0,R1
CP R0,min
SKIP NZ,0b01  ;Skip if this comparison is NOT true
BSET R2,0b00  ;toggle direction bit
CP R0,max
SKIP NZ,0b01  ;Skip if this comparison is NOT true
BCLR R2,0b00  ;toggle direction bit
GOSUB UpdateDisplay
GOTO oldMain

UpdateDisplay:
MOV R3, R0 ; stash last page

;test to inc or dec
BIT R2,0b00
SKIP Z,0b10
INC R1
SKIP NZ,0b01
DEC R1

MOV R0,0xF ;Write new. this is all on
MOV [R8:R1],R0
INC R8
MOV [R8:R1],R0 ; draw line across pages
DEC R8


;Erase old
MOV R0,0x0000000000000000
MOV [R8:R3],R0
INC R8
MOV [R8:R3],R0 ; draw line across pages
DEC R8

RET R0,0000+5-1+3-7


