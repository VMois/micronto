; -----------------------------------------------------------
; Microcontroller Based Systems Homework
; Author name: Moisieienkov Vladyslav
; Neptun code: ---
; -------------------------------------------------------------------
; Task description: 
; Find the highest order "1" bit in a 128 bit pattern being stored in the internal memory. 
; The subroutine must not modify the input array.
; Input: Start address of the pattern (pointer) in a register.
; Output: The bit position number of  the highest "1" bit (counted from the LSB) in a register. 
; If no "1" bit is present, the output is 0xFF.
; -------------------------------------------------------------------


; Definitions
; -------------------------------------------------------------------

; Address symbols for creating pointers

BITFIELD_LEN  EQU 16
BITFIELD_ADDR_IRAM  EQU 0x40

; Test data for input parameters
; Store the bitfield as bytes in the code memory

ORG 0x0070 ; Move if more code memory is required for the program code
BITFIELD_ADDR_CODE:
DB 0x00, 0x00, 0x00, 0x80, 0x55, 0xAA, 0xA0, 0xCC, 0x12, 0x13, 0x11, 0x10, 0x05, 0xAA, 0x42, 0x34
; Pattern in binary format (MSB first), correct answer is 103 (0x67):
; 0000 0000 0000 0000 0000 0000 1000 0000 0101 0101 1010 1010 1010 0000 1100 1100
; 0001 0010 0001 0011 0001 0001 0001 0000 0000 0101 1010 1010 0100 0010 0011 0100

BITFIELD_ADDR_CODE_FIRST_ONE:
DB 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
; Pattern in binary format (MSB first), correct answer is 127 (0x7F):
; 1000 0000 .... 0000 0000

BITFIELD_ADDR_CODE_LAST_ONE:
DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01
; Pattern in binary format (MSB first), correct answer is 0 (0x00):
; 0000 0000 .... 0000 0001

BITFIELD_ADDR_CODE_NO_ONE:
DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
; Pattern in binary format (MSB first), correct answer is 255 (0xFF):
; 0000 0000 .... 0000 0000

BITFIELD_ADDR_CODE_ANOTHER_EXAMPLE:
DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00
; Pattern in binary format (MSB first), correct answer is 9 (0x09):
; 0000 0000 .... 0000 0010 0000 0000

; Interrupt jump table
ORG 0x0000;
    SJMP  MAIN                  ; Reset vector

; Beginning of the user program, move it freely if needed
ORG 0x0010

; -------------------------------------------------------------------
; MAIN program
; -------------------------------------------------------------------
; Purpose: Prepare the inputs and call the subroutines
; -------------------------------------------------------------------

MAIN:

    ; Prepare input parameters for the subroutine
	MOV R5, #HIGH(BITFIELD_ADDR_CODE_ANOTHER_EXAMPLE)
	MOV R6, #LOW(BITFIELD_ADDR_CODE_ANOTHER_EXAMPLE)
	MOV R7, #BITFIELD_ADDR_IRAM
	CALL CODE2IRAM ; Copy the bitfield from code memory to internal memory
	
	MOV R7, #BITFIELD_ADDR_IRAM
; Infinite loop: Call the subroutine repeatedly
LOOP:

    CALL FIND_FIRST_1_NOMOD ; Call Find highest 1 bit subroutine

    SJMP  LOOP


; ===================================================================           
;                           SUBROUTINE(S)
; ===================================================================           


; -------------------------------------------------------------------
; CODE2IRAM
; -------------------------------------------------------------------
; Purpose: Copy the 128-but bitfield from code memory to internal memory in a big-endian format.
; -------------------------------------------------------------------
; INPUT(S):
;   R5 - Base address of the bitfield in code memory (high byte)
;   R6 - Base address of the bitfield in code memory (low byte)
;   R7 - Base address of the bitfield in the internal memory
; OUTPUT(S): 
;   -
; MODIFIES:
;   A, DPTR, R1, R7
; -------------------------------------------------------------------

CODE2IRAM:
    ; move base address to DPTR
    MOV DPH, R5
    MOV DPL, R6

    ; move R7 to R1 to be able to indirectly address memory later
    MOV A, R7
    MOV R1, A

    MOV R7, #BITFIELD_LEN

CODE2IRAM_LOOP:
    CLR A
    MOVC A, @A+DPTR
    MOV @R1, A
    INC DPTR
    INC R1
    DJNZ R7, CODE2IRAM_LOOP
    RET

; -------------------------------------------------------------------
; FIND_FIRST_1_NOMOD
; -------------------------------------------------------------------
; Finds the highest order "1" bit in a 128 bit pattern stored in the internal memory. 
; Note: The subroutine must not modify the input array.
; -------------------------------------------------------------------
; INPUT(S):
;   R7 - Base address of the 128-bit bitfield in the internal memory in big-endian format.
; OUTPUT(S): 
;   R5 - Position of the highest "1" bit, counted from LSB. The position number starts from zero.
; MODIFIES:
;   A, PSW, R1, R3, R4, R5
; -------------------------------------------------------------------

FIND_FIRST_1_NOMOD:
    ; load address to addressable register
    MOV A, R7
    MOV R1, A

    ; there are 16 bytes to check
    MOV R4, #BITFIELD_LEN

FIND_FIRST_1_NOMOD_LOOP:
    ; move current byte to R3
    MOV A, @R1
    MOV R3, A

    CALL FIND_FIRST_1_IN_BYTE

    ; check if we found "1" using XOR and mask 0xFF
    MOV A, R2
    XRL A, #255
    JNZ FIND_FIRST_1_NOMOD_FOUND

    ; step to the next byte
    INC R1

    ; check if we have remaining bytes to check
    DJNZ R4, FIND_FIRST_1_NOMOD_LOOP

    ; if "1" is NOT found in 128-bit input, return 0xFF
    MOV R5, #255
    RET

FIND_FIRST_1_NOMOD_FOUND:
    ; get position of the next byte
    DEC R4
    MOV A, R4

    ; 1 byte = 8 bit
    MOV B, #8

    ; calculate offset from the right side
    MUL AB

    ; add position of the highest "1" of the current byte to the calculated offset
    ADD A, R2

    MOV R5, A
    RET

; -------------------------------------------------------------------
; FIND_FIRST_1_IN_BYTE
; -------------------------------------------------------------------
; Finds the highest order "1" bit in a 8 bit. Assuming input is in big-endian format.
; -------------------------------------------------------------------
; INPUT(S):
;   R3 - Byte value in big-endian format.
; OUTPUT(S): 
;   R2 - Position of the highest "1" bit in a byte, if no "1" found returns 0xFF. Position is counted from zero.
; MODIFIES:
;   A, R2
; -------------------------------------------------------------------
FIND_FIRST_1_IN_BYTE:
    ; sets first position of 8 in a byte, fixed value
    MOV R2, #8
    MOV A, R3

FIND_FIRST_1_IN_BYTE_LOOP:
    JB 0xE7, FIND_FIRST_1_IN_BYTE_FOUND
    RL A
    DJNZ R2, FIND_FIRST_1_IN_BYTE_LOOP

    ; if "1" is not found
    MOV R2, #255 ; value of "0xFF" is not working in simulator
    RET

FIND_FIRST_1_IN_BYTE_FOUND:
    DEC R2
    RET

; End of the source file
END
