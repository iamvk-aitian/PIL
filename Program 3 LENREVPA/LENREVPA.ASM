DISP MACRO MSG  ; Macro used to  DISPLAY MESSAGE
  MOV AH,09H
  MOV DX,OFFSET MSG
  INT 21H
ENDM

.MODEL SMALL
.STACK 32
; ___________ DATA SEGMENT________

.DATA
MENU DB 10,13,"ENTER THE CHOICE",10,13,'1.LENGTH',10,13,"2.REVERSE",10,13,"3.PALLINDROME",10,13,"4.EXIT$"
MSG1 DB 10,13,"ENTER THE STRING $"
MSG2 DB 10,13,"LENGTH IS $"
MSG3 DB 10,13,"REVERSED STRING IS : $"
MSG4 DB 10,13,"STRING IS PALLINDROME $"
MSG5 DB 10,13,"STRING IS NOT PALLINDROME $"
MSG6 DB 10,13,"THANKS $"

STR1 DB 20,?,20 DUP(0)

;------------ CODE SEGMENT -----------
.CODE
        MOV AX,@DATA
        MOV DS,AX

   MEN: DISP MSG1
        MOV AH,0AH
        MOV DX,OFFSET STR1
        INT 21H

         DISP MENU

        MOV AH,01H
        INT 21H

        CMP AL,31H
        JE LENGTH1

        CMP AL,32H
        JE REVERSE1

        CMP AL,33H
        JE PALINDROME1

        JMP EXIT

        LENGTH1: CALL LENGTHS
        JMP MEN

        REVERSE1: CALL REVERSE
        JMP MEN

        PALINDROME1:CALL PALINDROME
        JMP MEN

        PROC LENGTHS NEAR

        DISP MSG2

        MOV SI,OFFSET STR1[1]
        MOV BL,[SI]

        MOV CX,02H

        B1: ROL BL,04H
            MOV DL,BL
            AND DL,0FH
            CMP DL,09h
            JBE NEXT1
            ADD DL,07H
            NEXT1:ADD DL,30H
                   MOV AH,02H
                   INT 21H
                   DEC CX
                   JNZ B1
                   RET
                   ENDP

                   PROC REVERSE NEAR
                   DISP MSG3

                   AND CX,00H
                   MOV SI,OFFSET STR1[1]
                   MOV CL,[SI]

                   ADD SI,CX
                   B2: MOV AH,02H
                       MOV DL,[SI]

                       INT 21H
                       DEC SI

                       DEC CX

                       JNZ B2

                       RET
                       ENDP

                       PROC PALINDROME NEAR
                       AND CX,00H
                       MOV SI,OFFSET STR1[1]
                       MOV CL,[SI]
                       ADD SI,CX
                       INC SI
                       MOV DI, OFFSET STR1[2]
                       DEC DI

                       B3:INC DI
                          DEC SI
                          MOV AL,[DI]

                          CMP AL,[SI]

                          JNE DONE

                          DEC CX

                          JNZ B3
                          DISP MSG4
                          RET
                        DONE: DISP MSG5
                        RET
                        ENDP

                        EXIT:
                        DISP MSG6
                        MOV AH,4CH
                        INT 21H
END
