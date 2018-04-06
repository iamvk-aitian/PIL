disp macro msg 
	mov ah,09H
	mov dx,offset msg
	int 21H
endm
.model small
	extrn str1:byte, str2:byte
	public compare
	public concat
.data
	str3 db 40 dup(0)
	msg1 db 10,13,"Concatinated String:- $"
	msg2 db 10,13,"Equal $"
	msg3 db 10,13,"Not Equal $"
.code 
	
	MOV AX,@Data
	mov ds,ax
	mov es,ax

	compare proc far

	lea si,str1[1]
	lea di,str2[1]
	mov cl,[si]
	inc cl

back:cmpsb
	jne nequal
	loop back
	disp msg2
	jmp exit
nequal: disp msg3

exit: mov ah,4ch
	int 21H
	endp

	concat proc far

	xor cx,cx
	lea si,str1[1]
	mov cl,[si]
	lea di,str3
	inc si
	rep movsb

	
	lea si,str2[1]
	mov cl,[si]
	INC SI 
	REP MOVSB
	
 	disp msg1
	
	lea si,str1[1]
	mov cl,[si]
	lea si,str2[1]
	add cl,[si]
	lea si,str3

back2: mov ah,02H
	mov dl,[si]
	int 21H
	inc si
	loop back2

	RET 
	ENDP
END
