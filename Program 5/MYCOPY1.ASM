.model small
.stack

.data
 msgpmiss   db 10,13,  "Required Parameter Missing$"
 msgillegal db 10,13,  "Illegal command or Insufficient Arguments $"
 openerr    db 10,13,  "Error In File Opening$"
 openerr1   db 10,13,  "Source File Does not exists$"
 over1      db 10,13,  "Destination File Already Exists Do You Want To Overwrite(Y/N)$"
 createrr   db 10,13,  "Error In File Creating$"
 writerr    db 10,13,  "Error In File Writing$"
 closerr    db 10,13,  "Error In File Closing$"
 readerr    db 10,13,  "Error In File Reading$"
 success    db 10,13,  "File Copied Successfuly....$"

 buff  db 15h dup(?)
 sname db 10h dup(0)
 dname db 10h dup(0)
 shandle dw ?
 dhandle dw ?                                                                    
 count   db ?
 actsize dw ?
 spacecntr db 0

        show macro var
        mov ah,09h
        lea dx,var
        int 21h
        endm            

.code

start:       mov ax,@data
        mov ds,ax     

        mov di,80h     
        
        mov al,es:[di]
        mov count,al  
       
        cmp count,00   
        jne next
        show msgpmiss
        jmp exit

next:   inc di
       	mov al,es:[di]
        cmp al,' '
        je next1

next1:  inc di
       	mov al,es:[di]
        cmp al,' '
        je next1
        inc spacecntr
        cmp al,0dh
        jne down1

        jmp next2

down1:  lea si,sname

up:       
          mov al,es:[di]
          cmp al,' '
       
          je next11

          mov [si],al
          inc di
          inc si
          jne up

next11:  inc di
       	mov al,es:[di]
        cmp al,' '
        je next11
        inc spacecntr
        cmp al,0dh
        jne down11

        jmp next2
        
down11: lea si, dname
up1:       mov al,es:[di]
           cmp al,0dh
           je next2
           mov [si],al
           inc di
           inc si
           jmp up1

next2: 
        cmp spacecntr,2
        je sur
        show msgillegal
        jmp exit

sur:    mov ah,4EH
         mov al,00
         lea dx,sname
         int 21h

         jnc der
         show openerr1
         jmp exit
                 
der:    mov ah,4eH
        mov al,00
        lea dx,dname
        int 21h

        jc open

        show over1
        mov ah,01h
        int 21h
        cmp al,'y'
        je  open
        cmp al,'Y'
        je open
        jmp exit


open:    mov ah,3dh
         mov al,00
         lea dx,sname
         int 21h
         jnc create
         show openerr
         jmp exit

create: mov shandle,ax

        mov ah,3ch
        mov cx,00
        lea dx,dname
        int 21h

        jnc opend
        show createrr
        jmp exit

opend :
        mov dhandle,ax

        mov ah,3dh
        mov al,02h
        lea dx,dname
        int 21h
        jnc read
        show openerr
        jmp exit

read:   mov ah,3fh
        mov bx,shandle
        mov cx,15h
        lea dx,buff
        int 21h

        jnc write
        show readerr
        jmp exit

write:  mov actsize, ax
        cmp ax,00
        jz close

        mov ah,40h
        mov bx,dhandle
        mov cx,actsize
       lea dx,buff
       int 21h

       jnc read
       show writerr
       jmp exit

close:  mov ah,3eh
        mov bx,shandle
        int 21h
        jnc dclose

        show closerr
        jmp exit

dclose: mov ah,3eh
        mov bx,dhandle
        int 21h

        jnc exit1
        show closerr
        jmp exit

exit1: show success

exit:   mov ah,4ch  
        int 21h 

        end start

