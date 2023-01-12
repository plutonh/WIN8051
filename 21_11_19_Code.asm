LCDWIR		EQU	0FFE0H
LCDWDR		EQU	0FFE1H
LCDRIR		EQU	0FFE2H
LCDRDR		EQU	0FFE3H

INST		EQU	20H
DATA		EQU	21H
LROW		EQU	22H
LCOL		EQU	23H
NUMFONT		EQU	24H
FDPL		EQU	25H
FDPH		EQU	26H

CLEAR		EQU	01H
CUR_HOME	EQU	02H
ENTRY2		EQU	06H
DCB6		EQU	0EH
FUN5		EQU 	0EH
LINE_1		EQU	80H
LINE_2		EQU	0C0H

		ORG	8000H

		MOV	INST,#FUN5
		CALL	INSTWR

		MOV	INST,#DCB6
		CALL	INSTWR

		MOV	INST,#CLEAR
		CALL	INSTWR

		MOV	INST,#FUN5
		CALL	INSTWR

		MOV	R0,#02H

MAIN:		DEC	R0
		MOV	LROW,#01H
		MOV	LCOL,R0
		CALL	CUR_MOV

		MOV	DPTR,#MESSAGE1
		MOV	FDPL,DPL
		MOV	FDPH,DPH
		MOV	NUMFONT,#0EH
		CALL	DISFONT

		MOV	LROW,#02H
		MOV	LCOL,R0
		CALL	CUR_MOV
		
		MOV	DPTR,#MESSAGE2
		MOV	FDPL,DPL
		MOV	FDPH,DPH
		MOV	NUMFONT,#0EH
		CALL	DISFONT

		CJNE 	R0,#00H,MAIN1
		MOV	R0,#14H

MAIN1:		CALL 	DELAY
		MOV 	INST,#CLEAR
		CALL 	INSTWR
		JMP	MAIN

DISFONT:	MOV	R5,#00H
		MOV	R6,LCOL

FLOOP:		MOV	LCOL,R6
		CALL	CUR_MOV
		MOV	DPL,FDPL
		MOV	DPH,FDPH
		MOV	A,R5
		MOVC	A,@A+DPTR
		MOV	DATA,A

		CALL	DATAWR
		INC	R5
		INC	R6
		CJNE	R6,#14H,DISFONT1
		MOV	R6,#00H

DISFONT1:	MOV	A,R5
		CJNE	A,NUMFONT,FLOOP
		RET

CUR_MOV:	MOV	A,LROW
		CJNE	A,#01H,NEXT
		MOV	A,#LINE_1
		ADD	A,LCOL
		MOV	INST,A
		CALL	INSTWR
		JMP	RET_POINT

NEXT:		CJNE	A,#02H,RET_POINT
		MOV	A,#LINE_2
		ADD	A,LCOL
		MOV	INST,A	
		CALL	INSTWR

RET_POINT:	RET

INSTWR:		CALL	INSTRD
		MOV	DPTR,#LCDWIR
		MOV	A,INST
		MOVX	@DPTR,A
		RET

DATAWR:		CALL	INSTRD
		MOV	DPTR,#LCDWDR
		MOV	A,DATA
		MOVX	@DPTR,A
		RET

INSTRD:		MOV	DPTR,#LCDRIR
		MOVX	A,@DPTR
		JB	ACC.7,INSTRD
		RET

MESSAGE1:	DB	'D','O',' ','Y','O'
		DB	'U','R',' ','B','E'
		DB	'S','T',' ','!'

MESSAGE2:	DB	'D','O',' ','Y','O'
		DB	'U','R',' ','B','E'
		DB	'S','T',' ','!'

DELAY:		MOV	R7,#07H
DELAY1:		MOV	R6,#0FFH
DELAY2:		MOV	R5,#0FFH
DELAY3:		DJNZ	R5,DELAY3
		DJNZ	R6,DELAY2
		DJNZ	R7,DELAY1
		RET

END