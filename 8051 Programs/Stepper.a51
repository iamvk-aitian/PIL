/*------------------Stepper Motor--------------------*/
/*
=============================================================================
Program in ASM Language to Demonstrate the Stepper Motor in FULL STEP MODE
                  on Micro-51 development Platform

Interfacing Pins :
                    P1.0 thru P1.3  connected to CN4.1 thru CN4.4 
-----------------------------------------------------------------------------
Jumper Settings:
	J1:2-3	J2:2-3	J3:2-3	J4:2-3	J5:1-2	J6:2-3
	DIP switches : OFF   
=============================================================================
*/

STEPPERPORT EQU P1

	org 0
	ljmp start		;jump to start on reset

	org 0x13		;External Interrupt service routine
	mov a,40h
	cpl a
	mov 40h,a
	reti

delay:
	mov r0,#00Fh
	mov r1,#00Fh
back:
	djnz r1,back
	djnz r0,back
	ret

;Lookup for clockwise and anti clockwise rotation
STEP_CLOCKWISE:
	DB 0x5, 0x9, 0xA, 0x6
STEP_ANTICLOCKWISE:
	DB 0x6, 0xA, 0x9, 0x5

;Routine to rotate clockwise
rotateclockwise:
	mov dptr,#STEP_CLOCKWISE
	mov r4,#04h
loop1:
	clr a
	movc a,@a+dptr
	mov STEPPERPORT,a
	lcall delay
	mov STEPPERPORT,#00
	inc dptr
	djnz r4,loop1
	ret

;Routine to rotate motor anticlockwise
rotateanticlockwise:
	mov dptr,#STEP_ANTICLOCKWISE
	mov r4,#04h
loop2:
	clr a
	movc a,@a+dptr
	mov STEPPERPORT,a
	lcall delay
	mov STEPPERPORT,#00
	inc dptr
	djnz r4,loop2
	ret

/*-----------------------------------------------
Configure INT0 (external interrupt 0) to generate
an interrupt on the falling-edge of /INT0 (P3.2).
Enable the EX0 interrupt and then enable the
global interrupt flag.
-----------------------------------------------*/

start:			//main program
	setb IT1   // Configure interrupt 1 for falling edge on /INT0 (P3.2)
	setb EX1    // Enable EX1 Interrupt
	setb EA    // Enable Global Interrupt Flag
	
	mov a,#0h
	mov 40h,a	//Variable used to identify the direction

continue:
	mov a,40h	//Get the currebt direction
	cjne a,#00h, clockwise
	lcall rotateanticlockwise
	sjmp continue
clockwise:
	lcall rotateclockwise
	 sjmp continue

END