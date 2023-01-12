; 21-2 마이크로프로세서 B반 5조 2018006417 남종현, 2018007029 정원묵, TeamProject - 뱀게임/Snake game


; PAUSE 기능을 INT0 키를 통해 구현하기 어려워 숫자 키패드 '5'로 대체하였습니다.

; 프로그램을 장시간 실행한 결과 컴퓨터의 연산속도가 느려져 1초당 사이클 처리 횟수가 적어지게 되므로 
; 시간이 지날수록 1초가 길어지는 현상이 있습니다.
; 따라서 프로그램을 작성하고 실행시킨 노트북을 기준으로 최대한 1초에 가깝게 설정하고자 노력하였습니다.

; ************************************************************************************
; KEY INTERFACE

DATA_OUT		EQU	0FFF0H   ; DATA_OUT의 주소
DATA_IN		EQU	0FFF1H   ; DATA_IN의 주소, KEY INTERFACE PDF 참고


; ************************************************************************************
; DEFINE FUNCTION KEY, KEY INTERFACE PDF 참고

RWKEY		EQU	10H	; READ AND WRITE KEY
COMMA		EQU	11H
PERIOD		EQU	12H
GO		EQU	13H	; GO-KEY
REG		EQU	14H	; REGISTER KEY
CD		EQU	15H	; DECREASE KEY
INCR		EQU	16H 	; INCREASE KEY
ST		EQU	17H 	; SINGLE STEP KEY
RST		EQU	18H 	; RST KEY
SCORE		EQU	19H	; 점수


; ************************************************************************************
; LED				; LED SEGMENT PDF 참고

SEG1		EQU	0FFC3H
SEG2		EQU	0FFC2H
SEG3		EQU	0FFC1H


; ************************************************************************************
; DOT MATRIX			; DOT MATRIX PDF 참고

COLGREEN	EQU	0FFC5H
COLRED		EQU	0FFC6H
ROW		EQU	0FFC7H
SROW		EQU	30H	; 뱀의 ROW 값 저장
SCOL		EQU	31H	; 뱀의 COL 값 저장
FROW		EQU	32H	; 먹이의 ROW 값 저장
FCOL		EQU	33H	; 먹이의 COL 값 저장
PKEY		EQU	34H	; 입력된 KEYPAD 값 저장
SECOND		EQU	35H	; 시간 변수 위치 선언


; ************************************************************************************
; LCD				; LCD PDF 참고

LCDWIR		EQU	0FFE0H	; LCD 읽기/쓰기 주소
LCDWDR		EQU	0FFE1H	; LCD DR 쓰기
LCDRIR 		EQU	0FFE2H	; LCD IR 읽기
LCDRDR		EQU	0FFE3H	; LCD DR 읽기


; ************************************************************************************
; DEFINE FUNCTION KEY		; LCD 변수 정의 PDF 참고

INST		EQU	20H	; LCD의 INSTRUCTION 값을 보관
DATA		EQU	21H	; LCD의 DATA 보관
EROW		EQU	22H	; LCD에 표시할 ROW 값 저장
ECOL		EQU	23H	; LCD에 표시할 COL 값 저장
NUMFONT		EQU	24H	; MESSAGE 전체 개수를 저장     
FDPL		EQU	25H	; DPL 값 저장
FDPH		EQU	26H	; DPH 값 저장


; ************************************************************************************
;DEFINE LCD INSTRUCTION

LCD_INST	EQU	01H


; ************************************************************************************
;CURSOR HOME

CUR_HOME	EQU	02H	; CURSOR HOME 위치로 이동


; ************************************************************************************
;커서 진행 방향 및 표시 이동 제어, 어드레스 1 증가, 커서나 블링크 오른쪽으로 이동

ENTRY2		EQU	06H     


; ************************************************************************************
;표시부 ON/OFF 제어

DCB6		EQU	0EH	; 표시(ON), 커서(ON), 블링크(OFF)


; ************************************************************************************
; FUNCTION SETTING

FUN5		EQU	38H	; 8비트 2행 5*7 1/16 듀티


; ************************************************************************************
; DDRAM ADDRESS SETTING

LINE_1		EQU	80H		; 1 000 0000 LCD 첫 번째 줄로 이동
LINE_2		EQU	0C0H		; 1 100 0000 LCD 두 번째 줄로 이동
		ORG	8000H

		MOV	SP,#40H		; INTERRUPT PDF참고


; ************************************************************************************
; INTERRUPT SETTING

	MOV	TMOD,#00000001B		; M10과 M00 BIT를 0과 1, 즉 MODE 3으로 실행 => 16BIT TIMER로 사용! 
	MOV	IP,#00000000B		; IP: INTERRUPT PRIOR, 외부 INTERRUPT 모두 차단 => 우선순위 DON'T CARE.
	MOV	IE,#10000010B		; ET0(ENABLE TIMER 0) ON, EA ON

	MOV	TH0,#00H		; TIMER HIGH 초기화
	MOV	TL0,#00H		; TIMER LOW 초기화
	MOV	R6,#30			; 코드를 작성한 컴퓨터를 기준으로 30이 1초와 가장 가까운 값을 얻을 수 있는 숫자입니다. 
					; 프로그램을 장시간 실행한 결과 컴퓨터의 연산속도가 느려져 1초당 사이클 처리 횟수가 적어지게 되므로 
					; 시간이 지날수록 1초가 길어지는 현상이 있습니다. 



; ************************************************************************************
; LCD 초기화	; LCD PDF 참고

LCD_CLEAR:	MOV	INST, #FUN5   
		CALL	INSTWR                            
              	MOV	INST, #DCB6    
		CALL	INSTWR
		MOV	INST, #LCD_INST   
		CALL	INSTWR
		MOV	INST, #ENTRY2
		CALL	INSTWR 


; ************************************************************************************
CLEAR:		; 초기 메세지를 표시

LCD_MESSAGE_CLEAR:
	
		MOV	EROW, #01H
		MOV	ECOL, #02H
		CALL	CUR_MOV			; 메시지 초기화, 커서위치 첫 번째 행, 두 번째 열
               
		MOV	DPTR, #MESSAGE_FSTART	; PRESS ANY KEY 문자열 입력
		MOV	FDPL, DPL
		MOV	FDPH, DPH            
		MOV	NUMFONT, #0EH		; 문자 수 15개
		CALL	DISFONT
                            
		MOV	EROW, #02H
		MOV	ECOL, #02H
		CALL	CUR_MOV			; 메시지 초기화, 커서위치 두 번째 행, 두 번째 열
 
		MOV	DPTR, #MESSAGE_SSTART	; TO START 문자열 입력
		MOV	FDPL, DPL
		MOV	FDPH, DPH                                 
		MOV	NUMFONT, #12H		; 문자 수 18개
		CALL	DISFONT


; ************************************************************************************
; 각종 변수 초기값 설정

	MOV	PKEY, #00H		; KEYPAD 초기화
	MOV	SECOND, #00H		; 시간 초기화
	MOV	SCORE, #00H		; 점수 초기화
	MOV	A, SCORE
	CALL	SEG
	CALL	DOTCOLG_CLEAR
	CALL	DOTCOLR_CLEAR		; DOT MATRIX 초기화
	MOV	SROW, #00001000B	; DOT MARTIX에서 뱀의 처음 위치 : 4번째 행
	MOV	SCOL, #00010000B	; DOT MARTIX에서 뱀의 처음 위치 : 5번째 열
	CALL	DOTCOLG			; DOT MATRIX에 초록색으로 뱀을 표시


; ************************************************************************************
; KEYPAD 입력 시 GAME_START

GAME_START:

	CLR	C
	MOV	PKEY, #00H

	CALL	FSCANN   		; 키 입력 발생하면 SCANN 함수에서 나와서 진행 

	MOV	TH0, #00010000B
	MOV	TL0, #00000000B

	SETB	TCON.TR0		; TIMER 시작, TCON(TIMER COUNT REGISTER)의 TIMER 0을 SETTING함.


; ************************************************************************************
LCD_DISFONT_TIME:	; 1초마다 1씩 증가시키고 LCD의 첫 번째 줄은 빈칸, 두 번째 줄에

		MOV	EROW, #01H		; LCD의 첫 번째 줄은 공란, 첫 줄 커서 위치 잡기
		MOV	ECOL, #02H
		CALL	CUR_MOV
		MOV	DPTR, #MESSAGE_CLEAR
		MOV	FDPL, DPL
		MOV	FDPH, DPH            
		MOV	NUMFONT, #0EH		; 문자 개수 총 14개
		CALL	DISFONT

		MOV	EROW, #02H		; LCD의 두 번째 줄에 SECOND 출력
		MOV	ECOL, #02H
		CALL	CUR_MOV
		MOV	DPTR, #NUMBER
		MOV	FDPL, DPL
		MOV	FDPH, DPH
		CALL	DISFONT_SECOND
		MOV	DPTR, #MESSAGE_CLEAR
		MOV	FDPL, DPL
		MOV	FDPH, DPH                                 
		MOV	NUMFONT, #0FH 		; 문자의 개수 총 15개
		CALL	DISFONT


; ************************************************************************************
; 처음에 생성될 먹이의 위치를 설정 

	MOV	A, TL0		; C언어의 RAND 함수와 같이 시간 데이터를 기반으로 한 난수 값을 이용하여 초반 먹이 위치 설정
	MOV	B,#03H   	; 2이외의 소수 3 사용
	MUL	AB
	MOV	R1, A		; R1에 위치 저장     
	MOV	A,#00000001B

	CALL	FCOL_SET
	CALL	FROW_SET


; ************************************************************************************
MAIN:		; 뱀과 먹이를 번갈아 가면서 DOT MATRIX에 표시하여 나타냄.

	CALL	KILL_FEED	; 뱀이 먹이를 먹었는지 확인. 뱀의 위치와 먹이의 위치를 비교.

	CALL	DOTCOLR_CLEAR	; 뱀이 먹이를 먹었든 안 먹었든 화면에 뱀의 위치를 표시하기 위해 초기화
	CALL	DOTCOLG		; DOT MATRIX에 뱀을 표시함
	CALL	DELAY		; 여기있는 딜레이 지우면 더빠르게깜빡여서 좋지않을까?
   
	CALL	DOTCOLG_CLEAR	; 위치 초기화
	CALL	DOTCOLR		; DOT MATRIX에 먹이를 표시함
	CALL	DELAY

	CALL	SSCANN
	JMP	MAIN


; ************************************************************************************
; 시작할 때 스캔하는 함수

FSCANN:
		PUSH	PSW	; PSW 값을 스택에 보관

CLEARIAL: 
		MOV	R1,#00H		; R1값을 초기화함 
		MOV	A,#11101111B	; 데이터 아웃의 처음값

COLSCAN:
		MOV	R0,A		; R0에 데이터 아웃 값을 보관 
		INC	R1		; R1 열의 값 보관, 루프돌때마다 +1 
		CALL	SUBKEY		; 키 패드에 입력된 상태를 조사함
		ANL	A,#00011111B	; 하나의 열이 5개의 성분으로 이루어짐->상위3비트제거
		XRL	A,#00011111B	; XRL 연산000111111->키패드입력=0이라서 0인 비트가 있는지 BITWISE 조사
		JNZ	RSCAN		; 값이 0아 아니면, 해당 열에 값이 있다는 것이므로 이제부터는 행을 조사
		MOV	A,R0           
		SETB	C 
		RRC	A		; 다음 열로 이동하기 위한 ROTATE RIGHT
		JNC	CLEARIAL	; 모든 열을 스캔했으면, 다시 시작 
		JMP	COLSCAN		; 아직 검사해야 할 열이 남아있으면 다음 열로 이동

RSCAN:
		MOV	R2,#00H		; 행의 값을 R2에 저장

ROWSCAN:
		RRC	A		; 어느 행이 1로 바뀌었는지 체크하기 위해 ROTATE RIGHT
		JC	MATRIX		; 캐리가 발생하면(값의 위치를 찾았다면), MATRIX로 이동
		INC	R2		; 캐리가 없으면 다음행으로 이동, R2에는 다음 행의 위치 값 저장. 
		JMP	ROWSCAN		; 다음 행으로 이동

MATRIX:
		MOV	A,R2		; R2에 들어있는 행의 값을 A에 저장
		MOV	B,#05H		; 1행은 5열
		MUL	AB		; 행렬의 행과 열의 2차원 배열을 1차원으로 바꿈
		ADD	A,R1		; R1에는 열의 값 저장, A = A+5*B(열+5*행)
		CALL	INDEX		; 입력된 값을 저장
		CALL	INPUT_PRESS	; 입력된 값이 무엇인지 판단하기 위한 함수
		POP	PSW		; 스택에서 PSW값을 가지고 옴
		RET			; 리턴


; ************************************************************************************
; 게임 LOOP마다 키패드 INTERRUPT를 체크함, KEY INTERFACE 예제에서 LED로 디스플레이 하는 것을, 키패드 입력을 체크하는 INPUT_PRESS로 분기한다고 바꾸기만 하면 됨.그 후  INPUT_PRESS에서 키패드로 입력된 숫자 혹은 문자가 무엇인지 찾고, 해당 입력에 맞는 기능을 구현하여 DOT MATRIX에 표시함.

SSCANN:		; KEY INTERFACE INTERRUPT 확인
		PUSH	PSW		; PSW 값을 스택에 보관
		MOV	R7, #0AH	; 임의 값 대입


SCLEARIAL:	
		DJNZ	R7, FINDKEY_CHECK
		POP	PSW
		RET


FINDKEY_CHECK: 
		MOV	R1, #00H	; R1값을 초기화함 
		MOV	A, #11101111B 	; 데이터 아웃의 처음값


SCOLSCAN:
		MOV	R0,A		; R0에 데이터 아웃 값을 보관 
		INC	R1		; R1 열의 값 보관, 루프돌때마다 +1 
		CALL	SUBKEY		; 키 패드에 입력된 상태를 조사함
		ANL	A,#00011111B	; 하나의 열이 5개의 성분으로 이루어짐->상위3비트제거
		XRL	A,#00011111B	; XRL 연산000111111->키패드입력=0이라서 0인 비트가 있는지 BITWISE 조사
		JNZ	SRSCAN		; 값이 0이 아니면, 해당 열에 값이 있다는 것이므로 이제부터는 행을 조사
		MOV	A,R0           
		SETB	C
		RRC	A		; 다음 열로 이동하기 위한 ROTATE RIGHT
		JNC	SCLEARIAL	; 모든 열을 스캔했으면, 다시 시작 
		JMP	SCOLSCAN	; 아직 검사해야 할 열이 남아있으면 다음 열로 이동

	
SRSCAN:
		MOV	R2,#00H		; 행의 값을 R2에 저장

SROWSCAN:
		RRC	A		; 어느행이 1로 바뀌었는지 체크하기 위해 ROTATE RIGHT
		JC	SMATRIX		; 캐리가 발생하면(값의 위치를 찾았다면), MATRIX로 분기
		INC	R2		; 캐리가 없으면 다음행으로 이동, R2에는 다음 행의 위치 값 저장. 
		JMP	SROWSCAN	; 다음 행의 스캔을 위한 분기


SMATRIX:
		MOV	A,R2		; R2에 들어있는 행의 값을 A에 저장
		MOV	B,#05H		; 1행은 5열
		MUL	AB		; 행렬의 행과 열의 2차원 배열을 1차원으로 바꿈
		ADD	A,R1		; R1에는 열의 값 저장, A = A+5*B(열+5*행)
		CALL	INDEX		; 입력된 값을 저장
		CALL	INPUT_PRESS	; 입력된 값이 무엇인지 판단하기 위한 함수
		POP	PSW		; 스택에서 PSW값을 가지고 옴
		RET			; 리턴


; ************************************************************************************
; KET INTERFACE 관련 함수, KEY INTERFACE 함수 참고

 
SUBKEY:		; DATA_OUT으로 데이터 내보내고 DATA_IN으로 결과 확인 
		MOV	DPTR, #DATA_OUT
		MOVX	@DPTR, A
		MOV	DPTR, #DATA_IN
		MOVX	A, @DPTR
		RET

INDEX:
		MOVC	A,@A+PC	; 누산기는 1 ~ 24의 값을 가진다.
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
		CJNE	A, #0AH, CHECK4		; 입력값이 A인지 체크 , 다르면 CHECK4로 점프
		MOV	PKEY,A
		CALL	MOVE
		RET

CHECK4:
		CJNE	A, #04H, CHECK1		; 입력값이 4인지 체크, 다르면 CHECK1로 점프
		MOV	PKEY,A
		CALL	MOVE
		RET

CHECK1:
		CJNE	A, #01H, CHECK6		; 입력값이 1인지 체크, 다르면 CHECK6으로 점프
		MOV	PKEY,A
		CALL	MOVE
		RET

CHECK6:
		CJNE	A, #06H, CHECK9		; 입력값이 6인지 체크, 다르면 CHECK9로 점프
		MOV	PKEY,A
		CALL	MOVE
		RET

CHECK9:
		CJNE	A, #09H, CHECK5		; 입력값이 9인지 체크, 다르면 CHECK5로 점프
		MOV	PKEY,A
		CALL	MOVE 
		RET

CHECK5:
		CJNE	A, #05H, NOMATCH	; 입력값이 5인지 체크, 다르면 NOMATCH로 점프
		MOV	PKEY,A
		CALL	MOVE

NOMATCH:
		RET

MOVE:
		MOV	A, PKEY

MOV_LEFT:
		CJNE	A, #04H, MOV_RIGHT	; 입력키가 '4'이면 아래의 명령 실행, 아니면 MOV_RIGHT 함수로 점프
		SETB	TCON.TR0		; '5' 키로 TCON.TR0=0으로 하여 PAUSE 하였을 때 'A', '4', '1', '6', '9' 키로 TCON.TR0=1로 설정하여 TIMER 재작동
		CALL	DELAY
		CALL	DELAY
		CALL	DELAY
		MOV	A,SCOL
		RRC	A			; RRC 연산을 실행하면 A의 값이 1/2배, 즉 열의 값이 감소하므로 결과적으로 뱀이 왼쪽으로 이동하며 A의 CARRY 값이 1이면 벽에 충돌
		
		JC	GAMEOVER		; GAMEOVER 함수로 점프
		MOV	SCOL, A			; 열의 값 갱신
		RET


MOV_RIGHT:
		CJNE	A, #06H MOV_UP		; 입력키가 '6'이면 아래의 명령 실행, 아니면 MOV_UP 함수로 점프
		SETB	TCON.TR0		; '5' 키로 TCON.TR0=0으로 하여 PAUSE 하였을 때 'A', '4', '1', '6', '9' 키로 TCON.TR0=1로 설정하여 TIMER 재작동 
		CALL	DELAY	
		CALL	DELAY
		CALL	DELAY
		MOV	A, SCOL
		RLC	A			; RLC 연산을 실행하면 A의 값이 2배, 즉 열의 값이 증가하므로 결과적으로 뱀이 오른쪽으로 이동하며 A의 CARRY 값이 1이면 벽에 충돌
		JC	GAMEOVER
		MOV	SCOL, A
		RET


MOV_UP:
		CJNE	A, #09H, MOV_DOWN	; 입력키가 '9'이면 아래의 명령 실행, 아니면 MOV_DOWN 함수로 점프
		SETB	TCON.TR0		; '5' 키로 TCON.TR0=0으로 하여 PAUSE 하였을 때 'A', '4', '1', '6', '9' 키로 TCON.TR0=1로 설정하여 TIMER 재작동
		CALL	DELAY
		CALL	DELAY
		CALL	DELAY
		MOV	A, SROW
		RRC	A			; RRC 연산을 실행하면 A의 값이 1/2배, 즉 행의 값이 감소하므로 결과적으로 뱀이 위쪽으로 이동하며 A의 CARRY 값이 1이면 벽에 충돌
		JC	GAMEOVER
		MOV	SROW, A			; 행의 값 갱신
		RET


MOV_DOWN:
		CJNE	A, #01H, MOV_RESET	; 입력키가 '1'이면 아래의 명령 실행, 아니면 MOV_RESET 함수로 점프
		SETB	TCON.TR0		; '5' 키로 TCON.TR0=0으로 하여 PAUSE 하였을 때 'A', '4', '1', '6', '9' 키로 TCON.TR0=1로 설정하여 TIMER 재작동
		CALL	DELAY
		CALL	DELAY
		CALL	DELAY
		MOV	A, SROW
		RLC	A			; RLC 연산을 실행하면 A의 값이 2배, 즉 행의 값이 증가하므로 결과적으로 뱀이 아래쪽으로 이동하며 A의 CARRY 값이 1이면 벽에 충돌
		JC	GAMEOVER
		MOV	SROW, A
		RET


MOV_RESET:
		CJNE	A, #05H, RESET		; 입력키가 '5'이면 아래의 명령 실행, 아니면 RESET 함수로 점프
		CALL	DELAY  
		CLR	TCON.TR0

; ************************************************************************************
; 5를 눌렀을 때 LCD에 문구 PAUSE를 표시

	MOV	EROW, #01H
	MOV	ECOL, #02H		; 첫번째 줄, 두번째 열부터 PAUSE 메시지를 넣을 것임
	CALL	CUR_MOV
	MOV	DPTR, #MESSAGE_PAUSE	; PAUSE라는 메시지를 입력
	MOV	FDPL, DPL
	MOV	FDPH, DPH            
	MOV	NUMFONT, #0EH		; 문자 수 총 14개
	CALL	DISFONT          
	MOV	EROW, #02H
	MOV	ECOL, #02H
	CALL	CUR_MOV
	RET    

RESET:		; 키패드 입력이 A일 때 다시 시작하는 함수
		CLR	TCON.TR0
		JMP	CLEAR


GAMEOVER:	; 죽으면 1) 빨간불 ON/OFF 반복, 2) GAME OVER 문구 LCD에 표시
		CLR	TCON.TR0
		MOV	SROW, #00H	 	; KILL SNAKE
		MOV	SCOL, #00H
		CALL	DOTCOLG			; DOT MATRIX에 빨간색 점등

GAMEOVER_RED:		; DOT MATRIX 전체가 빨간불이 껐다 켜졌다 반복
		MOV	FROW, #0FFH		; DOT MATRIX 전체에 빨간색 빛 점등
		MOV	FCOL, #0FFH
		CALL	DOTCOLR
		CALL	DELAY
		MOV	FROW, #00H		; DOT MATRIX 전체 빛 X
		MOV	FCOL, #00H
		CALL	DOTCOLR
		CALL	DELAY

LCD_DIE:	; 죽었으면 LCD에 Game Over 메시지를 첫 번째줄에 표시함.
		MOV	EROW, #01H
		MOV	ECOL, #02H
		CALL	CUR_MOV
		MOV	DPTR, #MESSAGE_DIE
		MOV	FDPL, DPL
		MOV	FDPH, DPH            
		MOV	NUMFONT, #0EH		; 문자 총 개수는 14개
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
		CALL	SSCANN			; SCAN해서 A가 입력되었는지 체크. 만약 A가 입력이 되었다면 CLEAR함수로 돌아가기 때문에 게임이 다시 시작됨. 
		JMP	GAMEOVER_RED		; A가 입력으로 들어오지 않았다면 계속해서 빨간불이 점등되어야함.   


KILL_FEED:	;뱀의 COL(SCOL)과 먹이의 COL(FCOL)이 같은지 확인.
		MOV	A, FCOL
		CJNE	A, SCOL, FAIL	; SNAKE와 FOOD의 열이 같지 않으면 FAIL

		;뱀의 COL(SROW)과 먹이의 ROW(FROW)이 같은지 확인.
		MOV	A, FROW		; SNAKE와 FOOD의 행이 같지 않으면 FAIL
		CJNE	A, SROW, FAIL


; ************************************************************************************
; 만약 열과 행이 모두 같았다면  먹이를 먹은 것이다! 그렇다면 점수를 1점 올려야한다.

	MOV	A, SCORE	; 현재 점수 값을 받아옴.
	INC	A
	MOV	SCORE, A
	DA	A
	CALL	SEG		; LED SEGMENT에 점수 출력


; ************************************************************************************
; 난수로 먹이 생성

	MOV	A,TL0           
	MOV	B,#03H   ; 2를 제외한 가장 작은 소수로 3 저장
	MUL	AB
	MOV	R1,A
	MOV	A,#01H


FCOL_SET:	; 난수로 만들어진 R1값을 1씩 감소시키는데, 이때 A라는 변수를 최상위비트부터 오른쪽으로 하나씩 옮겨감. 변수 A의 값은 생성될 먹이의 COL값
		MOV	R3, A		; #10000000B
		MOV	FCOL, A
		RR	A
		DJNZ	R1, FCOL_SET
		MOV	A, #10000000B 


FROW_SET:	; 난수로 만들어진 TL0값을 1씩 감소시키는데, 이때 A라는 변수를 최상위비트부터 오른쪽으로 하나씩 옮겨감. 변수 A의 값은 생성될 먹이의 ROW값
		MOV	R7, A		; #10000000B
		MOV	FROW, A
		RR	A
		DJNZ	TL0, FROW_SET
		MOV	A, #10000000B
		CALL	DOTCOLG_CLEAR 	; 먹이를 표시하는 것이기 때문에 뱀을 표시하는 초록색을 없앰.
		CALL	DOTCOLR		; 먹이를 표시하는 것이기 때문에 빨간색을 표시함.
		CALL	DELAY


FAIL:
		RET

; ************************************************************************************
; LED 관련 함수, 7-SEGMENT ARRAY PDF 참고

SEG:		; 7세그먼트 ARRAY 3개중 가장 오른쪽에 있는 세그먼트에 점수를 표시

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
; DOT MATRIX 관련 함수, DOT-MATRIX PDF 참고

DOTCOLG_CLEAR:	; GREEN COLOR로 초기화 
		MOV	DPTR, #COLGREEN
		MOV	A, #00
		MOVX	@DPTR, A

		MOV	DPTR, #ROW
		MOV	A, #0FFH  
		MOVX	@DPTR, A
		RET

DOTCOLR_CLEAR:	; RED COLOR로 초기화
		MOV	DPTR,  #COLRED
		MOV	A, #00H
		MOVX	@DPTR, A

		MOV	DPTR, #ROW
		MOV	A, #0FFH   
		MOVX	@DPTR,A
		RET

DOTCOLG:	; DOT MATRIX에 현재 뱀 위치 표시
		MOV	DPTR, #COLGREEN
                MOV	A, SCOL
                MOVX	@DPTR, A

                MOV	DPTR, #ROW
                MOV	A, SROW
                MOVX	@DPTR, A
                RET

DOTCOLR:	; DOT MATRIX에 현재 먹이 위치 표시
		MOV	DPTR, #COLRED
		MOV	A, FCOL
		MOVX	@DPTR, A

		MOV	DPTR, #ROW
		MOV	A, FROW
		MOVX	@DPTR, A
		RET


; ************************************************************************************
; LCD 관련 함수, LCD / INTERRUPT / TIMER PDF 참고

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
		MOV	B, #100		; SECOND에 저장된 시간 데이터를 100으로 나누어 시간(초)의 백의 자리 숫자 추출
		DIV	AB 		; A에는 몫, B에는 나머지를 저장
		MOV	DPL, FDPL
		MOV	DPH, FDPH
		MOVC	A, @A+DPTR	; DPTR은 #NUMBER를 갖고 있는데, 따라서 @DPTR(DPTR의 CONTENT=NUMBER가 갖고 있는 처음 CONTENT)은 0이다. 그렇기 때문에 @A+DPTR은 A라는 숫자가 같은 모양의 문자로 바뀐다. 따라서 해당 숫자가 LCD에 표시된다.
		MOV	DATA, A
		CALL	DATAWR

		MOV	A, B
		MOV	B, #10		; A에 저장된 시간 데이터를 10으로 나누어 십의 자리에 표시될 숫자 추출
		DIV	AB		; A에는 몫, B에는 나머지를 저장
		MOV	DPL, FDPL
		MOV	DPH, FDPH
		MOVC	A, @A+DPTR	
		MOV	DATA, A
		CALL	DATAWR

		MOV	A, B
		MOV	B, #10		; SECOND에 저장된 시간 데이터를 10으로 나누어 시간(초)의 십의 자리 숫자 추출
		DIV	AB		; A에는 몫, B에는 나머지를 저장
		MOV	A, B		; 여기서는 1의 자리 숫자를 얻어야 하기 때문에 몫이 아닌 나머지를 추출하여 LCD에 표시!
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
		MOV	TH0, #010H		; 서비스 루틴이 실행되었으니 다시 TH0과 TL0의 값을 처음과 같이 초기화 시켜준다
		MOV	TL0, #00H
		SETB	TCON.TR0
		DJNZ	R6, WAITING		; R6이 다 소모(ZERO)되면 시간을 센다(SECOND_COUNT), 소모되지 않았다면 ISR을 빠져나간다(1초가 되기엔 시간 미충족)
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
; INTERRUPT / INTERRUPT SERVICE ROUTINE 발생 할 경우

ORG	9F0BH
JMP	SERVICE

END