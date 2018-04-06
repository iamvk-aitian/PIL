
; Program to rotate stepper motor fast in clockwise direction

		ORG 00H
		MOV A, #66H
	BACK:	MOV P0, A
		RR A
		ACALL DELAY
		SJMP BACK

DELAY:
		MOV R2, #08H
	L1:	MOV R3, #0FH
		DJNZ R3, $
		DJNZ R2, L1
		RET

		END