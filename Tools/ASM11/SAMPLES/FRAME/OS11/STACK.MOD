;**********************************************************************
;* Module    : STACK.MOD
;* Programmer: Tony Papadimitriou
;* Purpose   : Stack handling routines
;* Language  : MC68HC11 (ASM11 v1.83+)
;* Status    : FREEWARE, Copyright (c) 1999 by Tony Papadimitriou
;* Segments  : RAM    : Variables
;*           : ROM    : Code
;*           : SEG9   : OS definitions (this allows adding more functions)
;* History   : 99.10.01 Original
;**********************************************************************

;Three routines are provided along with the required RAM
;
;1.  fInitStack - Initialize the Stack
;2.  fPush      - Push RegA byte on to the stack
;3.  fPull      - Pull a byte from the stack in RegA

#ifmain ;------------------------------------------------------------
                    #listoff
                    #include  COMMON.INC
                    #liston

                    #SEG9
                    org       $FF00
                    #ROM
                    org       $F800
#endif ;-------------------------------------------------------------

;********************************************************************
;*               LIBRARY ROUTINES FOR STACK MANIPULATION            *
;********************************************************************

?STACKSIZE          EQU       32                  ;size of Stack buffer in bytes

                    #RAM
?S.index            rmb       2                   ; -> first entry of Stack
?S.data             rmb       ?STACKSIZE

; ?S.index = $0000 indicates empty Stack condition



                    #SEG9
#ifndef OSCommands
OSCommands          equ       *
#endif

fInitStack          equ       *-OSCommands/2      ;Initialize the Stack
                    dw        ?InitStack

fPush               equ       *-OSCommands/2      ;Push RegA byte on to the stack
                    dw        ?Push

fPull               equ       *-OSCommands/2      ;Pull a byte from the stack in RegA
                    dw        ?Pull



                    #ROM
; Initialize the Stack structure before first time use
?InitStack          clr       ?S.index            ;make SP NIL
                    clr       ?S.index+1
                    ldx       #?S.data
?InitStack.Loop     clr       ,x
                    inx
                    cmpx      #?S.data+?STACKSIZE
                    blo       ?InitStack.Loop
                    rts

; Adds a byte to the end of the stack
; IN: RegA holds byte to push
?Push               pshx
                    ldx       ?S.index            ;get save position
                    beq       ?Push.First         ;first byte on stack
                    dex
                    cmpx      #?S.data            ;are past the allowed size?
                    bhs       ?Push.Save          ;no, continue
?ErrorX             pulx
?Error              sec                           ;general error exit
                    rts
?Push.First         ldx       #?S.data+?STACKSIZE-1
?Push.Save          stx       ?S.index
                    lda       A_,y                ;get parameter
                    sta       ,x                  ;save byte
?OKX                pulx
?OK                 clc
                    rts


; Removes a byte from the top of the stack
; OUT: RegA holds byte pulled
?Pull               pshx
                    ldx       ?S.index            ;get current index
                    beq       ?ErrorX             ;empty stack, exit with error
                    lda       ,x                  ;get value
                    sta       A_,y                ;return to caller
                    inx
                    cmpx      #?S.data+?STACKSIZE
                    bhs       ?Pull.NIL
?Pull.Save          stx       ?S.index            ;make it NIL (empty)
                    bra       ?OKX
?Pull.NIL           clrx
                    bra       ?Pull.Save

                    end