 jmp start
start: 
mov r0,#30H
mov a,#0
mov r2,a
mov r7,#0
back: inc r0
	  add a,@r0
	  
	  jnc next
	  inc r7
	  
	  next: 
	  djnz r2,back
	  mov r6,a
end	   