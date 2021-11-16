	ORG 8000h
SEG 	EQU 0FFC0h
	MOV R0, #20h
	MOV A, #088h ; A
	MOV @R0, A
	INC R0
	MOV A, #086h ; E
	MOV @R0, A
	INC R0
	MOV A, #0F9h ; I
	MOV @R0, A
	INC R0
	MOV A, #0C0h ; O
	MOV @R0, A
	INC R0
	MOV A, #0C1h ; U
	MOV @R0, A
	INC R0
	MOV A, #088h ; A
	MOV @R0, A
	INC R0
	MOV A, #086h ; E
	MOV @R0, A
	INC R0
	MOV A, #0F9h ; I
	MOV @R0, A
	INC R0
	MOV A, #0C0h ; 'O
	MOV @R0, A
	INC R0
	MOV A, #0C1h ; U
	MOV @R0, A
; Initialize counter number
	MOV R1, #0
loop:
	CALL display
	CALL Delay
	CALL Increase
	JMP loop
display:
	MOV A, #20h
	ADD A, R1
	MOV R0, A
	MOV A, @R0
	MOV DPTR, #SEG
	MOVX @DPTR, A
	RET
Increase:
	INC R1
	MOV A, R1
	SUBB A, #10
	JNZ skip
	MOV R1, #0
skip:
	RET
Delay: 	MOV R2, #20h
DELAY1: MOV R3, #0FFh
DELAY2: MOV R4, #0FFh
DELAY3: DJNZ R4, DELAY3
	DJNZ R3, DELAY2
	DJNZ R2, DELAY1
	RET
END