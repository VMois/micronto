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
; (Try also other values while testing your code.)

; Store the bitfield as bytes in the code memory

ORG 0x0070 ; Move if more code memory is required for the program code
BITFIELD_ADDR_CODE:
DB 0x00, 0x00, 0x00, 0x80, 0x55, 0xAA, 0xA0, 0xCC, 0x12, 0x13, 0x11, 0x10, 0x05, 0xAA, 0x42, 0x34
; Pattern in binary format (MSB first):
; 0000 0000 0000 0000 0000 0000 1000 0000 0101 0101 1010 1010 1010 0000 1100 1100
; 0001 0010 0001 0011 0001 0001 0001 0000 0000 0101 1010 1010 0100 0010 0011 0100

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
	MOV R5, #HIGH(BITFIELD_ADDR_CODE)
	MOV R6, #LOW(BITFIELD_ADDR_CODE)
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
; Purpose: Copy the 128-but bitfield from code memory to internal memory in a big-endian format
; -------------------------------------------------------------------
; INPUT(S):
;   R5 - Base address of the bitfield in code memory (high byte)
;   R6 - Base address of the bitfield in code memory (low byte)
;   R7 - Base address of the bitfield in the internal memory
; OUTPUT(S): 
;   -
; MODIFIES:
;   [TODO] R7, A, DPTR, R1 (needed for indirect adressing)
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
;   R7 - Base address of the 128-bit bitfield in the internal memory
; OUTPUT(S): 
;   R5 - Position of the highest "1" bit, counted from LSB (position counts from zero or one as long as I specified but better one)
; MODIFIES:
;   [TODO]
; -------------------------------------------------------------------

FIND_FIRST_1_NOMOD:

; [TODO: Place your code here]
    
    RET

; [TODO: You can also create other subroutines if needed.]



; End of the source file
END

