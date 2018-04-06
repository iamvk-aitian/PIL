
; Program to rotate stepper motor 180 degree in clockwise direction

		ORG 00H
		MOV R1, #100	;count value for 180 deg
		MOV A, #66H
	BACK:	MOV P0, A
		RR A
		ACALL DELAY
		DJNZ R1, BACK
		SJMP $

DELAY:
		MOV R2, #200
	L1:	MOV R3, #200
		DJNZ R3, $
		DJNZ R2, L1
		RET

		END
