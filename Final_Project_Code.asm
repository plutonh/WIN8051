; 21-2 ����ũ�����μ��� B�� 5�� 2018006417 ������, 2018007029 ������, TeamProject - �����/Snake game


; PAUSE ����� INT0 Ű�� ���� �����ϱ� ����� ���� Ű�е� '5'�� ��ü�Ͽ����ϴ�.

; ���α׷��� ��ð� ������ ��� ��ǻ���� ����ӵ��� ������ 1�ʴ� ����Ŭ ó�� Ƚ���� �������� �ǹǷ� 
; �ð��� �������� 1�ʰ� ������� ������ �ֽ��ϴ�.
; ���� ���α׷��� �ۼ��ϰ� �����Ų ��Ʈ���� �������� �ִ��� 1�ʿ� ������ �����ϰ��� ����Ͽ����ϴ�.

; ************************************************************************************
; KEY INTERFACE

DATA_OUT		EQU	0FFF0H   ; DATA_OUT�� �ּ�
DATA_IN		EQU	0FFF1H   ; DATA_IN�� �ּ�, KEY INTERFACE PDF ����


; ************************************************************************************
; DEFINE FUNCTION KEY, KEY INTERFACE PDF ����

RWKEY		EQU	10H	; READ AND WRITE KEY
COMMA		EQU	11H
PERIOD		EQU	12H
GO		EQU	13H	; GO-KEY
REG		EQU	14H	; REGISTER KEY
CD		EQU	15H	; DECREASE KEY
INCR		EQU	16H 	; INCREASE KEY
ST		EQU	17H 	; SINGLE STEP KEY
RST		EQU	18H 	; RST KEY
SCORE		EQU	19H	; ����


; ************************************************************************************
; LED				; LED SEGMENT PDF ����

SEG1		EQU	0FFC3H
SEG2		EQU	0FFC2H
SEG3		EQU	0FFC1H


; ************************************************************************************
; DOT MATRIX			; DOT MATRIX PDF ����

COLGREEN	EQU	0FFC5H
COLRED		EQU	0FFC6H
ROW		EQU	0FFC7H
SROW		EQU	30H	; ���� ROW �� ����
SCOL		EQU	31H	; ���� COL �� ����
FROW		EQU	32H	; ������ ROW �� ����
FCOL		EQU	33H	; ������ COL �� ����
PKEY		EQU	34H	; �Էµ� KEYPAD �� ����
SECOND		EQU	35H	; �ð� ���� ��ġ ����


; ************************************************************************************
; LCD				; LCD PDF ����

LCDWIR		EQU	0FFE0H	; LCD �б�/���� �ּ�
LCDWDR		EQU	0FFE1H	; LCD DR ����
LCDRIR 		EQU	0FFE2H	; LCD IR �б�
LCDRDR		EQU	0FFE3H	; LCD DR �б�


; ************************************************************************************
; DEFINE FUNCTION KEY		; LCD ���� ���� PDF ����

INST		EQU	20H	; LCD�� INSTRUCTION ���� ����
DATA		EQU	21H	; LCD�� DATA ����
EROW		EQU	22H	; LCD�� ǥ���� ROW �� ����
ECOL		EQU	23H	; LCD�� ǥ���� COL �� ����
NUMFONT		EQU	24H	; MESSAGE ��ü ������ ����     
FDPL		EQU	25H	; DPL �� ����
FDPH		EQU	26H	; DPH �� ����


; ************************************************************************************
;DEFINE LCD INSTRUCTION

LCD_INST	EQU	01H


; ************************************************************************************
;CURSOR HOME

CUR_HOME	EQU	02H	; CURSOR HOME ��ġ�� �̵�


; ************************************************************************************
;Ŀ�� ���� ���� �� ǥ�� �̵� ����, ��巹�� 1 ����, Ŀ���� ��ũ ���������� �̵�

ENTRY2		EQU	06H     


; ************************************************************************************
;ǥ�ú� ON/OFF ����

DCB6		EQU	0EH	; ǥ��(ON), Ŀ��(ON), ��ũ(OFF)


; ************************************************************************************
; FUNCTION SETTING

FUN5		EQU	38H	; 8��Ʈ 2�� 5*7 1/16 ��Ƽ


; ************************************************************************************
; DDRAM ADDRESS SETTING

LINE_1		EQU	80H		; 1 000 0000 LCD ù ��° �ٷ� �̵�
LINE_2		EQU	0C0H		; 1 100 0000 LCD �� ��° �ٷ� �̵�
		ORG	8000H

		MOV	SP,#40H		; INTERRUPT PDF����


; ************************************************************************************
; INTERRUPT SETTING

	MOV	TMOD,#00000001B		; M10�� M00 BIT�� 0�� 1, �� MODE 3���� ���� => 16BIT TIMER�� ���! 
	MOV	IP,#00000000B		; IP: INTERRUPT PRIOR, �ܺ� INTERRUPT ��� ���� => �켱���� DON'T CARE.
	MOV	IE,#10000010B		; ET0(ENABLE TIMER 0) ON, EA ON

	MOV	TH0,#00H		; TIMER HIGH �ʱ�ȭ
	MOV	TL0,#00H		; TIMER LOW �ʱ�ȭ
	MOV	R6,#30			; �ڵ带 �ۼ��� ��ǻ�͸� �������� 30�� 1�ʿ� ���� ����� ���� ���� �� �ִ� �����Դϴ�. 
					; ���α׷��� ��ð� ������ ��� ��ǻ���� ����ӵ��� ������ 1�ʴ� ����Ŭ ó�� Ƚ���� �������� �ǹǷ� 
					; �ð��� �������� 1�ʰ� ������� ������ �ֽ��ϴ�. 



; ************************************************************************************
; LCD �ʱ�ȭ	; LCD PDF ����

LCD_CLEAR:	MOV	INST, #FUN5   
		CALL	INSTWR                            
              	MOV	INST, #DCB6    
		CALL	INSTWR
		MOV	INST, #LCD_INST   
		CALL	INSTWR
		MOV	INST, #ENTRY2
		CALL	INSTWR 


; ************************************************************************************
CLEAR:		; �ʱ� �޼����� ǥ��

LCD_MESSAGE_CLEAR:
	
		MOV	EROW, #01H
		MOV	ECOL, #02H
		CALL	CUR_MOV			; �޽��� �ʱ�ȭ, Ŀ����ġ ù ��° ��, �� ��° ��
               
		MOV	DPTR, #MESSAGE_FSTART	; PRESS ANY KEY ���ڿ� �Է�
		MOV	FDPL, DPL
		MOV	FDPH, DPH            
		MOV	NUMFONT, #0EH		; ���� �� 15��
		CALL	DISFONT
                            
		MOV	EROW, #02H
		MOV	ECOL, #02H
		CALL	CUR_MOV			; �޽��� �ʱ�ȭ, Ŀ����ġ �� ��° ��, �� ��° ��
 
		MOV	DPTR, #MESSAGE_SSTART	; TO START ���ڿ� �Է�
		MOV	FDPL, DPL
		MOV	FDPH, DPH                                 
		MOV	NUMFONT, #12H		; ���� �� 18��
		CALL	DISFONT


; ************************************************************************************
; ���� ���� �ʱⰪ ����

	MOV	PKEY, #00H		; KEYPAD �ʱ�ȭ
	MOV	SECOND, #00H		; �ð� �ʱ�ȭ
	MOV	SCORE, #00H		; ���� �ʱ�ȭ
	MOV	A, SCORE
	CALL	SEG
	CALL	DOTCOLG_CLEAR
	CALL	DOTCOLR_CLEAR		; DOT MATRIX �ʱ�ȭ
	MOV	SROW, #00001000B	; DOT MARTIX���� ���� ó�� ��ġ : 4��° ��
	MOV	SCOL, #00010000B	; DOT MARTIX���� ���� ó�� ��ġ : 5��° ��
	CALL	DOTCOLG			; DOT MATRIX�� �ʷϻ����� ���� ǥ��


; ************************************************************************************
; KEYPAD �Է� �� GAME_START

GAME_START:

	CLR	C
	MOV	PKEY, #00H

	CALL	FSCANN   		; Ű �Է� �߻��ϸ� SCANN �Լ����� ���ͼ� ���� 

	MOV	TH0, #00010000B
	MOV	TL0, #00000000B

	SETB	TCON.TR0		; TIMER ����, TCON(TIMER COUNT REGISTER)�� TIMER 0�� SETTING��.


; ************************************************************************************
LCD_DISFONT_TIME:	; 1�ʸ��� 1�� ������Ű�� LCD�� ù ��° ���� ��ĭ, �� ��° �ٿ�

		MOV	EROW, #01H		; LCD�� ù ��° ���� ����, ù �� Ŀ�� ��ġ ���
		MOV	ECOL, #02H
		CALL	CUR_MOV
		MOV	DPTR, #MESSAGE_CLEAR
		MOV	FDPL, DPL
		MOV	FDPH, DPH            
		MOV	NUMFONT, #0EH		; ���� ���� �� 14��
		CALL	DISFONT

		MOV	EROW, #02H		; LCD�� �� ��° �ٿ� SECOND ���
		MOV	ECOL, #02H
		CALL	CUR_MOV
		MOV	DPTR, #NUMBER
		MOV	FDPL, DPL
		MOV	FDPH, DPH
		CALL	DISFONT_SECOND
		MOV	DPTR, #MESSAGE_CLEAR
		MOV	FDPL, DPL
		MOV	FDPH, DPH                                 
		MOV	NUMFONT, #0FH 		; ������ ���� �� 15��
		CALL	DISFONT


; ************************************************************************************
; ó���� ������ ������ ��ġ�� ���� 

	MOV	A, TL0		; C����� RAND �Լ��� ���� �ð� �����͸� ������� �� ���� ���� �̿��Ͽ� �ʹ� ���� ��ġ ����
	MOV	B,#03H   	; 2�̿��� �Ҽ� 3 ���
	MUL	AB
	MOV	R1, A		; R1�� ��ġ ����     
	MOV	A,#00000001B

	CALL	FCOL_SET
	CALL	FROW_SET


; ************************************************************************************
MAIN:		; ��� ���̸� ������ ���鼭 DOT MATRIX�� ǥ���Ͽ� ��Ÿ��.

	CALL	KILL_FEED	; ���� ���̸� �Ծ����� Ȯ��. ���� ��ġ�� ������ ��ġ�� ��.

	CALL	DOTCOLR_CLEAR	; ���� ���̸� �Ծ��� �� �Ծ��� ȭ�鿡 ���� ��ġ�� ǥ���ϱ� ���� �ʱ�ȭ
	CALL	DOTCOLG		; DOT MATRIX�� ���� ǥ����
	CALL	DELAY		; �����ִ� ������ ����� �������Ա������� ����������?
   
	CALL	DOTCOLG_CLEAR	; ��ġ �ʱ�ȭ
	CALL	DOTCOLR		; DOT MATRIX�� ���̸� ǥ����
	CALL	DELAY

	CALL	SSCANN
	JMP	MAIN


; ************************************************************************************
; ������ �� ��ĵ�ϴ� �Լ�

FSCANN:
		PUSH	PSW	; PSW ���� ���ÿ� ����

CLEARIAL: 
		MOV	R1,#00H		; R1���� �ʱ�ȭ�� 
		MOV	A,#11101111B	; ������ �ƿ��� ó����

COLSCAN:
		MOV	R0,A		; R0�� ������ �ƿ� ���� ���� 
		INC	R1		; R1 ���� �� ����, ������������ +1 
		CALL	SUBKEY		; Ű �е忡 �Էµ� ���¸� ������
		ANL	A,#00011111B	; �ϳ��� ���� 5���� �������� �̷����->����3��Ʈ����
		XRL	A,#00011111B	; XRL ����000111111->Ű�е��Է�=0�̶� 0�� ��Ʈ�� �ִ��� BITWISE ����
		JNZ	RSCAN		; ���� 0�� �ƴϸ�, �ش� ���� ���� �ִٴ� ���̹Ƿ� �������ʹ� ���� ����
		MOV	A,R0           
		SETB	C 
		RRC	A		; ���� ���� �̵��ϱ� ���� ROTATE RIGHT
		JNC	CLEARIAL	; ��� ���� ��ĵ������, �ٽ� ���� 
		JMP	COLSCAN		; ���� �˻��ؾ� �� ���� ���������� ���� ���� �̵�

RSCAN:
		MOV	R2,#00H		; ���� ���� R2�� ����

ROWSCAN:
		RRC	A		; ��� ���� 1�� �ٲ������ üũ�ϱ� ���� ROTATE RIGHT
		JC	MATRIX		; ĳ���� �߻��ϸ�(���� ��ġ�� ã�Ҵٸ�), MATRIX�� �̵�
		INC	R2		; ĳ���� ������ ���������� �̵�, R2���� ���� ���� ��ġ �� ����. 
		JMP	ROWSCAN		; ���� ������ �̵�

MATRIX:
		MOV	A,R2		; R2�� ����ִ� ���� ���� A�� ����
		MOV	B,#05H		; 1���� 5��
		MUL	AB		; ����� ��� ���� 2���� �迭�� 1�������� �ٲ�
		ADD	A,R1		; R1���� ���� �� ����, A = A+5*B(��+5*��)
		CALL	INDEX		; �Էµ� ���� ����
		CALL	INPUT_PRESS	; �Էµ� ���� �������� �Ǵ��ϱ� ���� �Լ�
		POP	PSW		; ���ÿ��� PSW���� ������ ��
		RET			; ����


; ************************************************************************************
; ���� LOOP���� Ű�е� INTERRUPT�� üũ��, KEY INTERFACE �������� LED�� ���÷��� �ϴ� ����, Ű�е� �Է��� üũ�ϴ� INPUT_PRESS�� �б��Ѵٰ� �ٲٱ⸸ �ϸ� ��.�� ��  INPUT_PRESS���� Ű�е�� �Էµ� ���� Ȥ�� ���ڰ� �������� ã��, �ش� �Է¿� �´� ����� �����Ͽ� DOT MATRIX�� ǥ����.

SSCANN:		; KEY INTERFACE INTERRUPT Ȯ��
		PUSH	PSW		; PSW ���� ���ÿ� ����
		MOV	R7, #0AH	; ���� �� ����


SCLEARIAL:	
		DJNZ	R7, FINDKEY_CHECK
		POP	PSW
		RET


FINDKEY_CHECK: 
		MOV	R1, #00H	; R1���� �ʱ�ȭ�� 
		MOV	A, #11101111B 	; ������ �ƿ��� ó����


SCOLSCAN:
		MOV	R0,A		; R0�� ������ �ƿ� ���� ���� 
		INC	R1		; R1 ���� �� ����, ������������ +1 
		CALL	SUBKEY		; Ű �е忡 �Էµ� ���¸� ������
		ANL	A,#00011111B	; �ϳ��� ���� 5���� �������� �̷����->����3��Ʈ����
		XRL	A,#00011111B	; XRL ����000111111->Ű�е��Է�=0�̶� 0�� ��Ʈ�� �ִ��� BITWISE ����
		JNZ	SRSCAN		; ���� 0�� �ƴϸ�, �ش� ���� ���� �ִٴ� ���̹Ƿ� �������ʹ� ���� ����
		MOV	A,R0           
		SETB	C
		RRC	A		; ���� ���� �̵��ϱ� ���� ROTATE RIGHT
		JNC	SCLEARIAL	; ��� ���� ��ĵ������, �ٽ� ���� 
		JMP	SCOLSCAN	; ���� �˻��ؾ� �� ���� ���������� ���� ���� �̵�

	
SRSCAN:
		MOV	R2,#00H		; ���� ���� R2�� ����

SROWSCAN:
		RRC	A		; ������� 1�� �ٲ������ üũ�ϱ� ���� ROTATE RIGHT
		JC	SMATRIX		; ĳ���� �߻��ϸ�(���� ��ġ�� ã�Ҵٸ�), MATRIX�� �б�
		INC	R2		; ĳ���� ������ ���������� �̵�, R2���� ���� ���� ��ġ �� ����. 
		JMP	SROWSCAN	; ���� ���� ��ĵ�� ���� �б�


SMATRIX:
		MOV	A,R2		; R2�� ����ִ� ���� ���� A�� ����
		MOV	B,#05H		; 1���� 5��
		MUL	AB		; ����� ��� ���� 2���� �迭�� 1�������� �ٲ�
		ADD	A,R1		; R1���� ���� �� ����, A = A+5*B(��+5*��)
		CALL	INDEX		; �Էµ� ���� ����
		CALL	INPUT_PRESS	; �Էµ� ���� �������� �Ǵ��ϱ� ���� �Լ�
		POP	PSW		; ���ÿ��� PSW���� ������ ��
		RET			; ����


; ************************************************************************************
; KET INTERFACE ���� �Լ�, KEY INTERFACE �Լ� ����

 
SUBKEY:		; DATA_OUT���� ������ �������� DATA_IN���� ��� Ȯ�� 
		MOV	DPTR, #DATA_OUT
		MOVX	@DPTR, A
		MOV	DPTR, #DATA_IN
		MOVX	A, @DPTR
		RET

INDEX:
		MOVC	A,@A+PC	; ������ 1 ~ 24�� ���� ������.
		RET

KEYBASE:
		DB ST		; SW1,ST		1
		DB INCR		; SW6,INCREASE		2
		DB CD		; SW11,CD		3
		DB REG		; SW15,REG		4
		DB GO		; SW19,GO		5
		DB 0CH		; SW2,C			6
		DB 0DH		; SW7,D			7
		DB 0EH		; SW12,E		8
		DB 0FH		; SW16,F		9
		DB COMMA	; SW20,COMMA (,)	10
		DB 08H		; SW3,8			11
		DB 09H		; SW8,9			12
		DB 0AH		; SW13,A		13
		DB 0BH		; SW17,B		14
		DB PERIOD	; SW21,PERIOD(.)	15
		DB 04H		; SW4,4			16
		DB 05H		; SW9,5			17
		DB 06H		; SW14,6		18
		DB 07H		; SW18,7		19
		DB RWKEY	; SW22,R/W		20
		DB 00H		; SW5,0			21
		DB 01H		; SW10,1		22
		DB 02H		; SW24,2		23
		DB 03H		; SW23,3		24
		;DB RST		; SW24  RST KEY		25


INPUT_PRESS:
		CJNE	A, #0AH, CHECK4		; �Է°��� A���� üũ , �ٸ��� CHECK4�� ����
		MOV	PKEY,A
		CALL	MOVE
		RET

CHECK4:
		CJNE	A, #04H, CHECK1		; �Է°��� 4���� üũ, �ٸ��� CHECK1�� ����
		MOV	PKEY,A
		CALL	MOVE
		RET

CHECK1:
		CJNE	A, #01H, CHECK6		; �Է°��� 1���� üũ, �ٸ��� CHECK6���� ����
		MOV	PKEY,A
		CALL	MOVE
		RET

CHECK6:
		CJNE	A, #06H, CHECK9		; �Է°��� 6���� üũ, �ٸ��� CHECK9�� ����
		MOV	PKEY,A
		CALL	MOVE
		RET

CHECK9:
		CJNE	A, #09H, CHECK5		; �Է°��� 9���� üũ, �ٸ��� CHECK5�� ����
		MOV	PKEY,A
		CALL	MOVE 
		RET

CHECK5:
		CJNE	A, #05H, NOMATCH	; �Է°��� 5���� üũ, �ٸ��� NOMATCH�� ����
		MOV	PKEY,A
		CALL	MOVE

NOMATCH:
		RET

MOVE:
		MOV	A, PKEY

MOV_LEFT:
		CJNE	A, #04H, MOV_RIGHT	; �Է�Ű�� '4'�̸� �Ʒ��� ��� ����, �ƴϸ� MOV_RIGHT �Լ��� ����
		SETB	TCON.TR0		; '5' Ű�� TCON.TR0=0���� �Ͽ� PAUSE �Ͽ��� �� 'A', '4', '1', '6', '9' Ű�� TCON.TR0=1�� �����Ͽ� TIMER ���۵�
		CALL	DELAY
		CALL	DELAY
		CALL	DELAY
		MOV	A,SCOL
		RRC	A			; RRC ������ �����ϸ� A�� ���� 1/2��, �� ���� ���� �����ϹǷ� ��������� ���� �������� �̵��ϸ� A�� CARRY ���� 1�̸� ���� �浹
		
		JC	GAMEOVER		; GAMEOVER �Լ��� ����
		MOV	SCOL, A			; ���� �� ����
		RET


MOV_RIGHT:
		CJNE	A, #06H MOV_UP		; �Է�Ű�� '6'�̸� �Ʒ��� ��� ����, �ƴϸ� MOV_UP �Լ��� ����
		SETB	TCON.TR0		; '5' Ű�� TCON.TR0=0���� �Ͽ� PAUSE �Ͽ��� �� 'A', '4', '1', '6', '9' Ű�� TCON.TR0=1�� �����Ͽ� TIMER ���۵� 
		CALL	DELAY	
		CALL	DELAY
		CALL	DELAY
		MOV	A, SCOL
		RLC	A			; RLC ������ �����ϸ� A�� ���� 2��, �� ���� ���� �����ϹǷ� ��������� ���� ���������� �̵��ϸ� A�� CARRY ���� 1�̸� ���� �浹
		JC	GAMEOVER
		MOV	SCOL, A
		RET


MOV_UP:
		CJNE	A, #09H, MOV_DOWN	; �Է�Ű�� '9'�̸� �Ʒ��� ��� ����, �ƴϸ� MOV_DOWN �Լ��� ����
		SETB	TCON.TR0		; '5' Ű�� TCON.TR0=0���� �Ͽ� PAUSE �Ͽ��� �� 'A', '4', '1', '6', '9' Ű�� TCON.TR0=1�� �����Ͽ� TIMER ���۵�
		CALL	DELAY
		CALL	DELAY
		CALL	DELAY
		MOV	A, SROW
		RRC	A			; RRC ������ �����ϸ� A�� ���� 1/2��, �� ���� ���� �����ϹǷ� ��������� ���� �������� �̵��ϸ� A�� CARRY ���� 1�̸� ���� �浹
		JC	GAMEOVER
		MOV	SROW, A			; ���� �� ����
		RET


MOV_DOWN:
		CJNE	A, #01H, MOV_RESET	; �Է�Ű�� '1'�̸� �Ʒ��� ��� ����, �ƴϸ� MOV_RESET �Լ��� ����
		SETB	TCON.TR0		; '5' Ű�� TCON.TR0=0���� �Ͽ� PAUSE �Ͽ��� �� 'A', '4', '1', '6', '9' Ű�� TCON.TR0=1�� �����Ͽ� TIMER ���۵�
		CALL	DELAY
		CALL	DELAY
		CALL	DELAY
		MOV	A, SROW
		RLC	A			; RLC ������ �����ϸ� A�� ���� 2��, �� ���� ���� �����ϹǷ� ��������� ���� �Ʒ������� �̵��ϸ� A�� CARRY ���� 1�̸� ���� �浹
		JC	GAMEOVER
		MOV	SROW, A
		RET


MOV_RESET:
		CJNE	A, #05H, RESET		; �Է�Ű�� '5'�̸� �Ʒ��� ��� ����, �ƴϸ� RESET �Լ��� ����
		CALL	DELAY  
		CLR	TCON.TR0

; ************************************************************************************
; 5�� ������ �� LCD�� ���� PAUSE�� ǥ��

	MOV	EROW, #01H
	MOV	ECOL, #02H		; ù��° ��, �ι�° ������ PAUSE �޽����� ���� ����
	CALL	CUR_MOV
	MOV	DPTR, #MESSAGE_PAUSE	; PAUSE��� �޽����� �Է�
	MOV	FDPL, DPL
	MOV	FDPH, DPH            
	MOV	NUMFONT, #0EH		; ���� �� �� 14��
	CALL	DISFONT          
	MOV	EROW, #02H
	MOV	ECOL, #02H
	CALL	CUR_MOV
	RET    

RESET:		; Ű�е� �Է��� A�� �� �ٽ� �����ϴ� �Լ�
		CLR	TCON.TR0
		JMP	CLEAR


GAMEOVER:	; ������ 1) ������ ON/OFF �ݺ�, 2) GAME OVER ���� LCD�� ǥ��
		CLR	TCON.TR0
		MOV	SROW, #00H	 	; KILL SNAKE
		MOV	SCOL, #00H
		CALL	DOTCOLG			; DOT MATRIX�� ������ ����

GAMEOVER_RED:		; DOT MATRIX ��ü�� �������� ���� ������ �ݺ�
		MOV	FROW, #0FFH		; DOT MATRIX ��ü�� ������ �� ����
		MOV	FCOL, #0FFH
		CALL	DOTCOLR
		CALL	DELAY
		MOV	FROW, #00H		; DOT MATRIX ��ü �� X
		MOV	FCOL, #00H
		CALL	DOTCOLR
		CALL	DELAY

LCD_DIE:	; �׾����� LCD�� Game Over �޽����� ù ��°�ٿ� ǥ����.
		MOV	EROW, #01H
		MOV	ECOL, #02H
		CALL	CUR_MOV
		MOV	DPTR, #MESSAGE_DIE
		MOV	FDPL, DPL
		MOV	FDPH, DPH            
		MOV	NUMFONT, #0EH		; ���� �� ������ 14��
		CALL	DISFONT  
		MOV	EROW, #02H
		MOV	ECOL, #02H
		CALL	CUR_MOV
		MOV	DPTR, #NUMBER
		MOV	FDPL, DPL
		MOV	FDPH, DPH
		CALL	DISFONT_SECOND
		MOV	DPTR, #MESSAGE_CLEAR
		MOV	FDPL, DPL
		MOV	FDPH, DPH                                 
		MOV	NUMFONT, #10H
		CALL	DISFONT
		MOV	PKEY, #00H
		CALL	SSCANN			; SCAN�ؼ� A�� �ԷµǾ����� üũ. ���� A�� �Է��� �Ǿ��ٸ� CLEAR�Լ��� ���ư��� ������ ������ �ٽ� ���۵�. 
		JMP	GAMEOVER_RED		; A�� �Է����� ������ �ʾҴٸ� ����ؼ� �������� ����Ǿ����.   


KILL_FEED:	;���� COL(SCOL)�� ������ COL(FCOL)�� ������ Ȯ��.
		MOV	A, FCOL
		CJNE	A, SCOL, FAIL	; SNAKE�� FOOD�� ���� ���� ������ FAIL

		;���� COL(SROW)�� ������ ROW(FROW)�� ������ Ȯ��.
		MOV	A, FROW		; SNAKE�� FOOD�� ���� ���� ������ FAIL
		CJNE	A, SROW, FAIL


; ************************************************************************************
; ���� ���� ���� ��� ���Ҵٸ�  ���̸� ���� ���̴�! �׷��ٸ� ������ 1�� �÷����Ѵ�.

	MOV	A, SCORE	; ���� ���� ���� �޾ƿ�.
	INC	A
	MOV	SCORE, A
	DA	A
	CALL	SEG		; LED SEGMENT�� ���� ���


; ************************************************************************************
; ������ ���� ����

	MOV	A,TL0           
	MOV	B,#03H   ; 2�� ������ ���� ���� �Ҽ��� 3 ����
	MUL	AB
	MOV	R1,A
	MOV	A,#01H


FCOL_SET:	; ������ ������� R1���� 1�� ���ҽ�Ű�µ�, �̶� A��� ������ �ֻ�����Ʈ���� ���������� �ϳ��� �Űܰ�. ���� A�� ���� ������ ������ COL��
		MOV	R3, A		; #10000000B
		MOV	FCOL, A
		RR	A
		DJNZ	R1, FCOL_SET
		MOV	A, #10000000B 


FROW_SET:	; ������ ������� TL0���� 1�� ���ҽ�Ű�µ�, �̶� A��� ������ �ֻ�����Ʈ���� ���������� �ϳ��� �Űܰ�. ���� A�� ���� ������ ������ ROW��
		MOV	R7, A		; #10000000B
		MOV	FROW, A
		RR	A
		DJNZ	TL0, FROW_SET
		MOV	A, #10000000B
		CALL	DOTCOLG_CLEAR 	; ���̸� ǥ���ϴ� ���̱� ������ ���� ǥ���ϴ� �ʷϻ��� ����.
		CALL	DOTCOLR		; ���̸� ǥ���ϴ� ���̱� ������ �������� ǥ����.
		CALL	DELAY


FAIL:
		RET

; ************************************************************************************
; LED ���� �Լ�, 7-SEGMENT ARRAY PDF ����

SEG:		; 7���׸�Ʈ ARRAY 3���� ���� �����ʿ� �ִ� ���׸�Ʈ�� ������ ǥ��

		MOV	DPTR, #SEG3
		MOVX	@DPTR, A

		MOV	A, #00H
		MOV	DPTR, #SEG2
		MOVX	@DPTR, A

		MOV	A, #00H
		MOV	DPTR, #SEG1
		MOVX	@DPTR, A
		RET


; ************************************************************************************
; DOT MATRIX ���� �Լ�, DOT-MATRIX PDF ����

DOTCOLG_CLEAR:	; GREEN COLOR�� �ʱ�ȭ 
		MOV	DPTR, #COLGREEN
		MOV	A, #00
		MOVX	@DPTR, A

		MOV	DPTR, #ROW
		MOV	A, #0FFH  
		MOVX	@DPTR, A
		RET

DOTCOLR_CLEAR:	; RED COLOR�� �ʱ�ȭ
		MOV	DPTR,  #COLRED
		MOV	A, #00H
		MOVX	@DPTR, A

		MOV	DPTR, #ROW
		MOV	A, #0FFH   
		MOVX	@DPTR,A
		RET

DOTCOLG:	; DOT MATRIX�� ���� �� ��ġ ǥ��
		MOV	DPTR, #COLGREEN
                MOV	A, SCOL
                MOVX	@DPTR, A

                MOV	DPTR, #ROW
                MOV	A, SROW
                MOVX	@DPTR, A
                RET

DOTCOLR:	; DOT MATRIX�� ���� ���� ��ġ ǥ��
		MOV	DPTR, #COLRED
		MOV	A, FCOL
		MOVX	@DPTR, A

		MOV	DPTR, #ROW
		MOV	A, FROW
		MOVX	@DPTR, A
		RET


; ************************************************************************************
; LCD ���� �Լ�, LCD / INTERRUPT / TIMER PDF ����

DISFONT:
		MOV	R4, #00H 


FLOOP:
		MOV	DPL, FDPL
		MOV	DPH, FDPH 
		MOV	A, R4
		MOVC	A, @A+DPTR                 
		MOV	DATA, A
		CALL	DATAWR
		INC	R4
		MOV	A, R4
		CJNE	A, NUMFONT, FLOOP
		RET


DISFONT_SECOND:
		MOV	A, SECOND
		MOV	B, #100		; SECOND�� ����� �ð� �����͸� 100���� ������ �ð�(��)�� ���� �ڸ� ���� ����
		DIV	AB 		; A���� ��, B���� �������� ����
		MOV	DPL, FDPL
		MOV	DPH, FDPH
		MOVC	A, @A+DPTR	; DPTR�� #NUMBER�� ���� �ִµ�, ���� @DPTR(DPTR�� CONTENT=NUMBER�� ���� �ִ� ó�� CONTENT)�� 0�̴�. �׷��� ������ @A+DPTR�� A��� ���ڰ� ���� ����� ���ڷ� �ٲ��. ���� �ش� ���ڰ� LCD�� ǥ�õȴ�.
		MOV	DATA, A
		CALL	DATAWR

		MOV	A, B
		MOV	B, #10		; A�� ����� �ð� �����͸� 10���� ������ ���� �ڸ��� ǥ�õ� ���� ����
		DIV	AB		; A���� ��, B���� �������� ����
		MOV	DPL, FDPL
		MOV	DPH, FDPH
		MOVC	A, @A+DPTR	
		MOV	DATA, A
		CALL	DATAWR

		MOV	A, B
		MOV	B, #10		; SECOND�� ����� �ð� �����͸� 10���� ������ �ð�(��)�� ���� �ڸ� ���� ����
		DIV	AB		; A���� ��, B���� �������� ����
		MOV	A, B		; ���⼭�� 1�� �ڸ� ���ڸ� ���� �ϱ� ������ ���� �ƴ� �������� �����Ͽ� LCD�� ǥ��!
		MOV	DPL, FDPL
		MOV	DPH, FDPH
		MOVC	A, @A+DPTR
		MOV	DATA, A
		CALL	DATAWR
		RET        


CUR_MOV:
		MOV	A, EROW
		CJNE	A, #01H, NEXT
		MOV	A, #LINE_1
		ADD	A, ECOL
		MOV	INST, A
		CALL	INSTWR
		JMP	RET_SPOT              


NEXT:		CJNE	A, #02H, RET_SPOT
		MOV	A, #LINE_2
		ADD	A, ECOL
		MOV	INST, A 
		CALL	INSTWR          


RET_SPOT:
		RET



INSTRD:
		MOV	DPTR, #LCDRIR
		MOVX	A, @DPTR
		JB	ACC.7, INSTRD 
		RET


INSTWR:
		CALL     INSTRD
		MOV      DPTR, #LCDWIR
		MOV      A, INST
		MOVX     @DPTR, A 
		RET


DATAWR:		
		CALL     INSTRD
		MOV      DPTR, #LCDWDR
		MOV      A, DATA
		MOVX     @DPTR, A
		RET


NUMBER:
		DB '0', '1', '2', '3', '4'
		DB '5', '6', '7', '8', '9'


MESSAGE_CLEAR:
		DB ' ', ' ', ' ', ' ', ' ' 
		DB ' ', ' ', ' ', ' ', ' '
		DB ' ', ' ', ' ', ' ', ' '
		DB ' ', ' ', ' ', ' ', ' '


MESSAGE_DIE:
		DB 'G', 'a', 'm', 'e', ' '
		DB 'O', 'v', 'e', 'r', ' '
		DB ' ', ' ', ' ', ' '


MESSAGE_FSTART:
		DB 'P', 'r', 'e', 's', 's'
		DB ' ', 'A', 'n', 'y', ' '
		DB 'K', 'e', 'y', ' '
            
MESSAGE_SSTART:
		DB 't', 'o', ' ', 'S', 't' 
		DB 'a', 'r', 't', ' ', ' '
		DB ' ','  ', ' ', ' ', ' '
		DB ' ', ' ', ' '


MESSAGE_PAUSE:
		DB 'P', 'A', 'U', 'S', 'E'
		DB ' ', ' ', ' ', ' ', ' '
		DB ' ', ' ', ' ', ' '


SERVICE:
		CLR	TCON.TR0
		MOV	TH0, #010H		; ���� ��ƾ�� ����Ǿ����� �ٽ� TH0�� TL0�� ���� ó���� ���� �ʱ�ȭ �����ش�
		MOV	TL0, #00H
		SETB	TCON.TR0
		DJNZ	R6, WAITING		; R6�� �� �Ҹ�(ZERO)�Ǹ� �ð��� ����(SECOND_COUNT), �Ҹ���� �ʾҴٸ� ISR�� ����������(1�ʰ� �Ǳ⿣ �ð� ������)
		JMP	SECOND_COUNT    


WAITING:
		RETI


SECOND_COUNT:
		MOV	R6, #60 
		MOV	A, SECOND
		INC	A
		MOV	SECOND, A
		MOV	EROW, #01H
		MOV	ECOL, #02H
		CALL	CUR_MOV
		MOV	DPTR, #MESSAGE_CLEAR
		MOV	FDPL, DPL
		MOV	FDPH, DPH
		CALL	DISFONT
		MOV	EROW, #02H
		MOV	ECOL, #02H
		CALL	CUR_MOV
		MOV	DPTR, #NUMBER
		MOV	FDPL, DPL
		MOV	FDPH, DPH
		CALL	DISFONT_SECOND
		RETI

; ************************************************************************************

DELAY:		MOV	R2, #02H 
DELAY1:		MOV	R1, #0FFH 
DELAY2:		MOV	R0, #0FFH 
DELAY3:		DJNZ	R0, DELAY3
		DJNZ	R1, DELAY2
		DJNZ	R2, DELAY1
		RET


; ************************************************************************************
; INTERRUPT / INTERRUPT SERVICE ROUTINE �߻� �� ���

ORG	9F0BH
JMP	SERVICE

END