	ORG	8000h

SEG1	EQU	0FFC3h
SEG2	EQU	0FFC2h
SEG3 	EQU	0FFC1h

	MOV 	R4,#26
	MOV	R5,#10

;display R4 on SEG1
	MOV	A,R4
	MOV	B,#10
	DIV	AB
;A<-Quotient of A/10
	MOV	R2,A
;B<-Remainder of A/10
	MOV 	R3,B
	MOV	A,R2
	SWAP	A
	ORL	A,R3
	MOV	DPTR,#SEG1
	MOVX	@DPTR,A

;display R5 on SEG2
	MOV	A,R5
	MOV	B,#10
	DIV	AB
;A<-Quotient of A/10
	MOV	R2,A
;B<-Remainder of A/10
	MOV 	R3,B
	MOV	A,R2
	SWAP	A
	ORL	A,R3
	MOV	DPTR,#SEG2
	MOVX	@DPTR,A

;display Remainder on SEG3
	MOV	A,R4
	MOV	B,R5
	DIV	AB
	MOV	R4,B
	MOV	A,R4
	MOV	B,#10
	DIV	AB
;A<-Quotient of A/10
	MOV	R2,A
;B<-Remainder of A/10
	MOV 	R3,B
	MOV	A,R2
	SWAP	A
	ORL	A,R3
	MOV	DPTR,#SEG3
	MOVX	@DPTR,A

END