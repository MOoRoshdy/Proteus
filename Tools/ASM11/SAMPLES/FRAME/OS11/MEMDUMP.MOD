;**********************************************************************
;* Module    : MEMDUMP.MOD
;* Programmer: Tony Papadimitriou
;* Purpose   : Memory dump routines
;* Language  : MC68HC11 (ASM11 v1.84+)
;* Status    : FREEWARE, Copyright (c) 1999 by Tony Papadimitriou
;* Segments  : RAM    : Variables
;*           : ROM    : Code
;*           : SEG9   : OS definitions (this allows adding more functions)
;* History   : 99.11.23 v1.00 Original (6809 version March 22, 1991)
;*           : 99.11.25 v1.01 Added fPagedDump
;*           : 99.11.27 v1.02 Added ESC check in fMemDump (and fPagedDump)
;**********************************************************************

#ifmain ;------------------------------------------------------------
                    #LISTOFF
                    #INCLUDE  711E9.INC
                    #INCLUDE  COMMON.INC
                    #INCLUDE  OS11/OSERRORS.INC
                    #LISTON

                    #SEG9
                    org       $FF00

                    #include  OS11/SCI_INT.MOD
#endif ;-------------------------------------------------------------

                    #SEG9
#ifndef OSCommands
OSCommands          equ       *
#endif

fMemDump            equ       *-OSCommands/2
                    dw        ?MemDump

fPagedDump          equ       *-OSCommands/2
                    dw        ?PagedDump

#PAGE ;Operating System routines expanded
**********************************************************************
*                 Operating System routines expanded                 *
**********************************************************************

?BUFFER_SIZE        equ       73
?Y                  equ       ?BUFFER_SIZE+2      ;to access caller's stack frame

                    #ROM

; Purpose: Dump in hex a memory range
; Input  : X -> beginning address
;        : Y -> ending address
; Output : Carry Set if ESC pressed, Clear otherwise
?MemDump            jsr       ?PrintHeaders
                    ldx       X_,Y                ;X -> first address to dump
                    gety      #?BUFFER_SIZE       ;get buffer and extras

                    clrb                          ;counter modulo 16

?MemDump.Main       bsr       ?ClearBuffer
                    bsr       ?PutAddress
?MemDump.Loop       bsr       ?PutData

                    inx                           ;point to next data
                    beq       ?MemDump.Exit
                    cmpx      Y_+?Y,Y
                    bhi       ?MemDump.Exit

                    incb
                    andb      #$0F                ;B := B mod 16
                    bne       ?MemDump.Loop

                    xgxy
                    os        fWritelnZ           ;print the output buffer
                    xgxy

                    os        fGetPossibleChar
                    bcs       ?MemDump.Main
                    cmpa      #ESC
                    bne       ?MemDump.Main
                    bra       ?MemDump.Exit2

?MemDump.Exit       xgxy
                    os        fWritelnZ           ;print the output buffer
                    givey     #?BUFFER_SIZE       ;return buffer
                    rts

?MemDump.Exit2      givey     #?BUFFER_SIZE       ;return buffer
                    ldb       B_,Y
                    sec
                    rts

;IN : X = address
?PutAddress         pshd
                    pshx
                    xgdx
                    pshb
                    bsr       ?ToHex              ;high address byte
                    std       ,Y
                    pula                          ;low address byte
                    bsr       ?ToHex
                    std       2,Y
                    pulx
                    puld
                    rts

?PutData            pshd
                    pshy
                    lda       ,X                  ;get current byte
                    aby
                    psha
                    bsr       ?ChangeToDot        ;change to dot if required
                    sta       56,Y                ;save it in output buffer
                    pula
                    aby:2
                    bsr       ?ToHex              ;convert to ASCII string
                    std       6,Y                 ;save it in output buffer
                    puly
                    puld
                    rts

; Clear the buffer with spaces and end-of-line markers
; IN: Y points to buffer
?ClearBuffer        pshd
                    pshy
                    ldd       #' '<8|?BUFFER_SIZE
?ClearBuffer.Loop   sta       ,Y
                    iny
                    decb
                    bne       ?ClearBuffer.Loop
                    puly
                    clr       ?BUFFER_SIZE-1,Y    ;and make it ASCIZ string
                    puld
                    rts

;IN : A=value
;OUT: D=2 character ASCII equivalent
?ToHex              tab                           ;save A in B
                    lsra:4                        ;down 4 bits
                    bsr       ?ToLetter           ;convert to hex letter in A
                    psha
                    tba                           ;get back original value
                    anda      #$0F                ;mask off MSN
                    bsr       ?ToLetter           ;--- do the above for second nibble ---
                    tab
                    pula
                    rts

;A=[IN] value (LSN) [OUT] hex digit
?ToLetter           cmpa      #10                 ;if less than 10, it's a number
                    blo       ?ToNumber
                    adda      #'A'-'0'-10
?ToNumber           adda      #'0'
                    rts

?ChangeToDot        cmpa      #' '
                    bhs       ?ChangeToDot.Exit
                    lda       #'.'                ;unprintable character masking
?ChangeToDot.Exit   rts

?PrintHeaders       os        fPrint
                    fcc       CR,LF,'OS-11 Memory Dump Module v1.01',CR,LF,LF
                    fcc       'Addr  00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F   0123456789ABCDEF',CR,LF
                    fcs       '----  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   ----------------',CR,LF
                    rts

; Purpose: Call fMemDump in pages of 256 bytes each.
; Input  : X -> beginning address
; Output : None
; Note(s): Keypress goes to next page.  ESC terminates.
;        : Ending address is always $FFFF but ESC can terminate before that.
?PagedDump          ldx       X_,y
                    pshx                          ;Y := X
                    puly
                    dey                           ;Y := Y - 1 (first time only)

?PagedDump.Loop     os        fPrint              ;clear the terminal screen
                    fcs       FF
                    xgdy
                    addd      #$100               ;Y := Y + $100
                    cmpd      #$FF                ;if Y < $FF then Y := $FFFF
                    bhs       ?PagedDump.GoOn
                    ldd       #$FFFF
?PagedDump.GoOn     xgdy
                    os        fMemDump
                    bcs       ?PagedDump.Exit

                    xgdx
                    addd      #$100               ;X := X + $100
                    xgdx
                    cmpy      #$FFFF              ;if Y <> $FFFF then repeat
                    beq       ?PagedDump.Exit

                    os        fPrint
                    fcs       CR,LF,'Press any key to continue... (or ESC to stop)'
                    os        fGetChar
                    os        fPrint
                    fcs       CR,'                                             ',CR
                    cmpa      #ESC
                    jne       ?PagedDump.Loop

?PagedDump.Exit     clc
                    rts

#ifmain
                    #include  OS11/DISPATCH.MOD
#endif