; Location is SRAM where to put data
SRAM_BEGIN: EQU 4082


; Sony HBI-55 Data Cartridge / Yamaha UDC-01 Data Memory
; read on address 0 must return #53
; 4kb, usable bytes 1-4095

; read from cartridge
; HL = address
; returns A
; note: read address does not increase after read like in VRAM
HBI55_READ:
	LD	A, #89
	OUT	(#B3), A
	LD	A, L
	OUT	(#B0), A
	LD	A, H
	OR	#C0
	OUT	(#B1), A
	IN	A, (#B2)
	RET

; write to cartridge
; HL = address
; C = value to write
; note: write address does not increase after write like in VRAM
HBI55_WRITE:
	LD	A, #80
	OUT	(#B3), A
	LD	A, L
	OUT	(#B0), A
	LD	A, H
	OR	#40
	OUT	(#B1), A
	LD	A, C
	OUT	(#B2), A
	RET	

; Detect presence of SRAM
; if header is not detected and player chooses to user SRAM then write header and init content
; sets variable sramcart to 1
SRAM_MODULE_MSG:
DB "SRAM module detected!", 13, 10, "Use it for storing high score ?", 13, 10, "(Y/N) ", 0
SRAM_MODULE_INIT:
	LD	HL, 0
	CALL	HBI55_READ
	CP	#53
	RET NZ
	; check for header 'BP'
	; if present set variable
	LD	HL, SRAM_BEGIN
	CALL	HBI55_READ
	CP	'B'
	JR	NZ, SRAM_MODULE_INIT_L0
	INC	HL
	CALL	HBI55_READ
	CP	'P'
	JR	Z, SRAM_MODULE_INIT_L3
SRAM_MODULE_INIT_L0:
	; SCREEN 0
	LD	A, 0
	CALL	CHGMOD
	LD	HL, SRAM_MODULE_MSG
SRAM_MODULE_INIT_L1:
	LD	A, (HL)
	OR	A
	JR	Z, SRAM_MODULE_INIT_L2
	CALL	CHPUT
	INC	HL
	JR	SRAM_MODULE_INIT_L1
SRAM_MODULE_INIT_L2:
	CALL	CHGET
	CP	'Y'
	JR	Z, SRAM_MODULE_INIT_L4
	CP	'y'
    JR  Z, SRAM_MODULE_INIT_L4
    CP  'N'
    RET Z
    CP  'n'
    RET Z
	JR  SRAM_MODULE_INIT_L2
SRAM_MODULE_INIT_L4:
    ; write header and initial state
    LD	HL, SRAM_BEGIN
    LD  C, 'B'
    CALL HBI55_WRITE
    INC HL
    LD  C, 'P'
    CALL HBI55_WRITE
    LD  B, 6
    LD  C, 0
 SRAM_MODULE_INIT_L5:
    INC HL
    CALL HBI55_WRITE
    DJNZ SRAM_MODULE_INIT_L5   
SRAM_MODULE_INIT_L3:
	LD	A, 1
	LD	(sramcart), A
    CALL READ_HISCORE_FROM_SRAM
	RET

; read hiscore from cart if sramcart=1
READ_HISCORE_FROM_SRAM:
    PUSH AF
    PUSH HL
    PUSH DE
    PUSH BC
    LD  A, (sramcart)
    OR  A
    JR  Z, READ_HISCORE_FROM_SRAM_END
    LD  HL, SRAM_BEGIN+2
    LD  DE, hiscore+1
    LD  B, 6
READ_HISCORE_FROM_SRAM_L1:
    CALL HBI55_READ
    LD  (DE), A
    INC HL
    INC DE
    DJNZ READ_HISCORE_FROM_SRAM_L1
READ_HISCORE_FROM_SRAM_END:
    POP BC
    POP DE
    POP HL
    POP AF
    RET

; write hiscore to cart if sramcart=1
WRITE_HISCORE_TO_SRAM:
    PUSH AF
    PUSH HL
    PUSH DE
    PUSH BC
    LD  A, (sramcart)
    OR  A
    JR  Z, WRITE_HISCORE_TO_SRAM_END
    LD  HL, SRAM_BEGIN+2
    LD  DE, hiscore+1
    LD  B, 6
WRITE_HISCORE_TO_SRAM_L1:
    LD  A, (DE)
    LD  C, A
    CALL HBI55_WRITE
    INC HL
    INC DE
    DJNZ WRITE_HISCORE_TO_SRAM_L1
WRITE_HISCORE_TO_SRAM_END:
    POP BC
    POP DE
    POP HL
    POP AF
    RET