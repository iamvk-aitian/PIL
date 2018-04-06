/*------------------ADC 0801---------------------*/
/*
=========================================================================================
Program in ASM Language to Demonstrate the ADC 0801 on Micro-51 development Platform

Peripheral: ADC0801.
-----------------------------------------------------------------------------------------
Interfacing Pins :
	Data Port	:P1.0 - P1.7
	ADCCS 		:P2.0
	ADCRDBAR 	:P2.1
	ADCWRBAR	:P2.2
	ADCINTR		:P2.3
-----------------------------------------------------------------------------------------
Jumper Settings:
	J1: Any	J2:2-3 J3:1-2
	J4: 2-3 J5:2-3 J6:1-2 DIP: OFF
=========================================================================================
*/

ADCPORT 	EQU 	P1
ADCCS 		EQU		P2^0
ADCRDBAR 	EQU		P2^1
ADCWRBAR	EQU 	P2^2
ADCINTR		EQU		P2^3
RS  		EQU 	P3^2
EN  		EQU 	P3^3

	org 0
	ljmp start


Delay:							
	mov r0,#0Fh
	mov r1,#03h
here:	
	djnz r1, here
	mov r1,#03h
	djnz r0, here
	ret

lDelay:
	mov r2, #0FFh
loop1:
	mov r3, #10h
loop2:
	acall Delay
	djnz r3, loop2
	djnz r2, loop1
	ret


ReadADC:
start_conv:
	setb ADCINTR 
	setb ADCCS
	setb ADCWRBAR
	setb ADCRDBAR

	clr ADCCS				//Select the ADC
	lcall Delay
	clr ADCWRBAR			//H to L transition
	lcall Delay
	setb ADCCS

waitforintr:
	jnb ADCINTR, ReadData
	sjmp waitforintr

ReadData:
	clr ADCCS
	lcall delay
	clr ADCRDBAR
	lcall Delay
	mov a, ADCPORT;	
	lcall Delay
	setb ADCWRBAR
	setb ADCRDBAR
	setb ADCINTR 
	setb ADCCS
	ret


write_lcd_data:
	mov P0,A		;Write the value on port P0
	mov r6,#05h		;Call delay for 5mS
continue1:
	lcall Delay
	djnz r6, continue1
	SETB RS
	SETB EN
	mov r6,#01h		;Call delay for 1mS
continue2:
	lcall Delay
	djnz r6, continue2
	MOV P3,#00		; clear the control signals
	ret

;Subroutine to send command to LCD

write_lcd_cmd:
	mov P0,A		;Write the value on port P0
	mov r6,#0ah		;Call delay for 5mS
continue3:
	lcall Delay
	djnz r6, continue3
	SETB EN
	mov r6,#01h		;Call delay for 1mS
continue4:
	lcall Delay
	djnz r6, continue4
	MOV P3,#00		; clear the control signals
	ret
	



start:
	mov a,#0x38				; //function set
	lcall write_lcd_cmd
	mov a,#0x08				; //display off
	lcall write_lcd_cmd
	mov a,#0x01				; //display clear
	lcall write_lcd_cmd
	mov a,#0x06				; //entry mode set
	lcall write_lcd_cmd
	mov a,#0x0f				; //display on
	lcall write_lcd_cmd
	mov a,#0x80				; //set address counter value
	lcall write_lcd_cmd

loop:
	mov a, #80h
	acall write_lcd_cmd	;set cursor 1st line 1st position
	acall ReadADC
	mov b,#02h
	mul ab				;5000mV -> 255 (adc)			also 10mV -> 1^C
						;5000mV -> 500^C -> 255 (adc)
						;1(adc) -> 500/255 -> 1.97 = approx 2 
						;hence multiply adc result by 2 to get temp in ^C

	mov b, #100		 	;hundreds place
	div ab
	orl a, #30h			;to ASCII
	acall write_lcd_data

	mov a,b
	mov b, #10			;tens place
	div ab
	orl a, #30h
	acall write_lcd_data

	mov a,b 			;units place
	orl a, #30h
	acall write_lcd_data

	acall lDelay
	sjmp loop

	end
	