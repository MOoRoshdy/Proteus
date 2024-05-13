;**********************************************************************
;* Module    : QUEUE.MOD
;* Programmer: Tony Papadimitriou
;* Purpose   : Queue handling routines
;* Language  : MC68HC11 (ASM11 v1.83+)
;* Status    : FREEWARE, Copyright (c) 1999 by Tony Papadimitriou
;* Segments  : RAM    : Variables
;*           : ROM    : Code
;*           : SEG9   : OS definitions (this allows adding more functions)
;* History   : 99.09.30 Original
;**********************************************************************

;Three routines are provided along with the required RAM
;
;1.  fInitQ - Initialize the Queue
;2.  fEnQ   - Put RegA byte in the queue
;3.  fDeQ   - Get a byte from the queue in RegA

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
;*               LIBRARY ROUTINES FOR QUEUE MANIPULATION            *
;********************************************************************

?QUEUESIZE          EQU       32                  ;size of Queue buffer in bytes (one byte not used)

                    #RAM
?Q.first            rmb       2                   ; -> first entry of Queue
?Q.last             rmb       2                   ; -> last entry of Queue (next available)
?Q.data             rmb       ?QUEUESIZE

; ?Q.first = ?Q.last indicates empty Queue condition

                    #SEG9
#ifndef OSCommands
OSCommands          equ       *
#endif

fInitQ              equ       *-OSCommands/2
                    dw        ?InitQ

fEnq                equ       *-OSCommands/2
                    dw        ?EnQ

fDeq                equ       *-OSCommands/2
                    dw        ?DeQ

                    #ROM
; Initialize the Queue structure before first time use
?InitQ              ldx       #?Q.data            ;make both pointers
                    stx       ?Q.first            ;the same, indicating
                    stx       ?Q.last             ;"queue empty" condition
?InitQ.Loop         clr       ,x
                    inx
                    cmpx      #?Q.data+?QUEUESIZE
                    blo       ?InitQ.Loop
?OK                 clc                           ;general no error exit
?AnRTS              rts

?Error              sec                           ;general error exit
                    rts

; Adds a byte to the end of the queue
; IN: RegA holds byte to enqueue
?EnQ                ldx       ?Q.last             ;get save position
                    pshx
                    bsr       ?EnlargeQ           ;prepare new index in ?Q.last
                    pulx
                    bcs       ?Error              ;exit with error
?EnQ.Add            lda       A_,y                ;get parameter byte
                    sta       ,x                  ;save byte
                    clc
                    rts

; Adjust queue index to make queue bigger
?EnlargeQ           ldx       ?Q.last             ;get current index
                    inx                           ;point to next location
                    cmpx      #?Q.data+?QUEUESIZE ;must we wraparound
                    blo       ?EnlargeQ.NoWrap
                    ldx       #?Q.data            ;reset to beginning of buffer
?EnlargeQ.NoWrap    cmpx      ?Q.first            ;is it the same as the first pointer
                    beq       ?Error              ;yes, queue is FULL
                    stx       ?Q.last             ;else, save new index
                    clc                           ;no error exit
                    rts

; Removes a byte from the beginning of the queue
; OUT: RegA holds byte dequeued
?DeQ                ldx       ?Q.first            ;get current index
                    cmpx      ?Q.last             ;check empty condition
                    beq       ?Error              ;exit with error

                    lda       ,x                  ;get value
                    sta       A_,y                ;return it to caller

; Adjust queue index to make queue smaller
?ShrinkQ            ldx       ?Q.first            ;get current index
                    inx                           ;point to next location
                    cmpx      #?Q.data+?QUEUESIZE ;must we wraparound
                    blo       ?ShrinkQ.NoWrap
                    ldx       #?Q.data            ;reset to beginning of buffer
?ShrinkQ.NoWrap     stx       ?Q.first            ;save new index
                    clc                           ;no error exit
                    rts