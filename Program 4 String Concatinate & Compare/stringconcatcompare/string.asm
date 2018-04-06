disp macro msg ; macro to accept Input
	mov ah,09H ; 
	mov dx,offset msg
	int 21H
endm
.model small
	extrn compare:far
	extrn concat:far
	public str1,str2
.data
	num db ?
	str1 db 20,?,20 dup(0)
	str2 db 20,?,20 dup(0)
	msg1 db 10,13,"Enter the string :- $" 
	msg2 db 10,13,"1.Compare",10,13,"2:Concat",10,13,"Enter your Choice :- $" 
.code
	MOV AX,@Data
	mov ds,ax
	mov es,ax

	disp msg1
	mov ah,0ah ;  accept the line of string
	lea dx,str1
	int 21H

	disp msg1
	mov ah,0ah ;  accept the line of string
	lea dx,str2
	int 21H

	disp msg2
	mov ah,01H
	int 21H

	cmp al,31H
	je len1

	cmp al,32H
	je len2

	jmp exit

len1: call compare
	jmp exit

len2: call concat
	jmp exit

exit: mov ah,4ch
	int 21H

end
