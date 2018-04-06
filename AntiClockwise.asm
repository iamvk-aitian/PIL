
; Program to rotate stepper motor in Anti clockwise direction

		ORG 00H
		MOV A, #66H
	BACK:	MOV P0, A
		RL A
		ACALL DELAY
		SJMP BACK

DELAY:
		MOV R2, #0FFH
	L1:	MOV R3, #0FFH
		DJNZ R3, $
		DJNZ R2, L1
		RET

		END