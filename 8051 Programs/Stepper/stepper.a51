org 0
ljmp start
delay: 
	mov r0,#0ffH
	back1: mov r1,#000H
	back:
		djnz r1,back
		djnz r0,back1
		ret
		step_clockwise: db 0x5,0x9,0xA,0x6
		step_anticlockwise: db 0x6,0xA,0x9,0x5

		start:
			mov dptr,#STEP_ANTICLOCKWISE
			mov R4,#04H
		loop1: 
			clr a
			movc a,@a+dptr
			mov p1,a
			lcall delay
			mov p1,00H
			inc dptr
			djnz r4,loop1
			sjmp start
			end  
