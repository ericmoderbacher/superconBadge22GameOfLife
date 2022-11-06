#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}



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