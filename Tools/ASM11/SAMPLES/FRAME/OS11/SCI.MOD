;**********************************************************************
;* Module    : SCI.MOD
;* Programmer: Tony Papadimitriou
;* Purpose   : SCI-related OS-called routines
;* Language  : MC68HC11 (ASM11 v1.83+)
;* Status    : FREEWARE, Copyright (c) 1999 by Tony Papadimitriou
;* Segments  : RAM    : Variables
;*           : ROM    : Code
;*           : SEG9   : OS definitions (this allows adding more functions)
;* History   : 99.10.31 v1.00 Original (copied from 99.10.26 OS11.MOD)
;*           : 99.11.12 v1.01 Added fGetChar
;*           : 99.11.14       Change fSetBaud to polled mode only (simpler)
;*           : 99.11.27 v1.02 Added fGetPossibleChar (doesn't wait for char)
;**********************************************************************

#ifmain
                    #LISTOFF
                    #INCLUDE  811E2.INC
                    #INCLUDE  COMMON.INC
                    #INCLUDE  OSERRORS.INC
                    #LISTON

                    #SEG9
                    ORG       $FF00
#endif

                    #SEG9
#ifndef OSCommands
OSCommands          equ       *
#endif

fError              equ       *-OSCommands/2      ;Print error message on the SCI
                    dw        ?Error

fErrorJump          equ       *-OSCommands/2      ;fError and jump to address
                    dw        ?ErrorJump

fUsrErrorJump       equ       *-OSCommands/2      ;Like fErrorJump with User error
                    dw        ?UsrErrorJump

fSetBAUD            equ       *-OSCommands/2      ;Set SCI bps ("baud") rate
                    dw        ?SetBAUD

fPrint              equ       *-OSCommands/2      ;Print the following FCS string
                    dw        ?Print

fGetPossibleChar    equ       *-OSCommands/2      ;Read SCI char is present into RegA
                    dw        ?GetPossibleChar

fGetChar            equ       *-OSCommands/2      ;Read SCI char into RegA
                    dw        ?GetChar

fPutChar            equ       *-OSCommands/2      ;Write RegA character to the SCI
                    dw        ?PutChar

fWrite              equ       *-OSCommands/2      ;Write a "Pascal" string to SCI
                    dw        ?Write

fWriteln            equ       *-OSCommands/2      ;fWrite followed by CR,LF pair
                    dw        ?Writeln

fNewLine            equ       *-OSCommands/2      ;Send a CR,LF pair to the SCI
                    dw        ?NewLine

fWriteZ             equ       *-OSCommands/2      ;Write an ASCIZ string to SCI
                    dw        ?WriteZ

fWritelnZ           equ       *-OSCommands/2      ;fWriteZ followed by CR,LF pair
                    dw        ?WritelnZ

#PAGE ;Operating System routines expanded
**********************************************************************
*                 Operating System routines expanded                 *
**********************************************************************
                    #ROM

; Purpose: Print error message on the SCI and jump to address in X
; Input  : B holds error code
;        : X holds address to jump to after printing error
; Output : None
?ErrorJump          ldx       X_,y                ;get address to jump to
                    stx       PC_,y               ;and use it as return PC
          ; fall through to fError (do not change fError's location)

; Purpose: Print error message on the SCI
; Input  : B holds error code
; Output : None
; Note(s): Uses fPrint, fWritelnZ
?Error              ldb       B_,y                ;get error code
                    beq       ?Error.Exit         ;not an error
                    decb                          ;make error zero-based
                    clra                          ;we'll be using D
                    lsld                          ;multiply by size of table entries
                    cmpd      #?Error.Size        ;is it within our table size
                    bhs       ?Error.Exit         ;invalid error code, get out
                    addd      #?Error.Table       ;point to beginning of table
                    xgdx                          ;put pointer in X
                    ldx       ,x                  ;get pointer to error msg
                    os        fPrint              ;print standard error header
                    fcs       CR,LF,'OS ERROR('
                    os        fWritelnZ
?Error.Exit         clc
                    rts

?Error.Table        dw        ?Error.1
                    dw        ?Error.2
                    dw        ?Error.3
                    dw        ?Error.4
                    dw        ?Error.5
                    dw        ?Error.6
?Error.Size         equ       *-?Error.Table/2

?Error.1            fcs       '1): Other'
?Error.2            fcs       '2): Invalid Call'
?Error.3            fcs       '3): Bad Parameter'
?Error.4            fcs       '4): Failed'
?Error.5            fcs       '5): Out Of Range'
?Error.6            fcs       '6): Not found'

; Purpose: Print user error message on the SCI
; Input  : Y -> user error message
;        : X holds address to jump to after printing error
; Output : None
; Note(s): Uses fPrint, fWritelnZ
?UsrErrorJump
                    os        fPrint              ;print standard error header
                    fcs       CR,LF,'ERROR: '
                    ldx       Y_,y                ;get pointer to error msg
                    os        fWritelnZ
                    ldx       X_,y                ;set user address
                    stx       PC_,y               ;..to return to
                    clc
                    rts

; Purpose: Set SCI BAUD rate to one of the following values (in A_,y)
;          3(00), 12(00), 24(00), 48(00), 96(00), 125(000)
;          (use number outside parentheses for corresponding baud rate)
; Input  : RegA = Baud Rate (without trailing zeros)
; Note(s): Assumes 8MHz XTAL (2MHz E-Clock)
?BPS_Table          db        3,$35               ;300 bps (user value, MCU value)
                    db        12,$33              ;1200 bps
                    db        24,$34              ;2400 bps
                    db        48,$31              ;4800 bps
                    db        96,$30              ;9600 bps
                    db        125,$00             ;125000 bps
?BPS_Table.Entries  equ       *-?BPS_Table/2      ;number of entries in table

?SetBAUD            lda       A_,y                ;get user bps rate value
                    ldx       #?BPS_Table         ;point to table with MCU bps rates
                    ldb       #?BPS_Table.Entries ;get number of entries to test
?SetBAUD.BpsLoop    cmpa      ,x                  ;is it the same as in table?
                    beq       ?SetBAUD.SetBAUD    ;go set it
                    inx:2                         ;point to next entry
                    decb                          ;are we done with all entries?
                    bne       ?SetBAUD.BpsLoop    ;if not, try again
?SetBAUD.Error      ldb       #errBadParm         ;not found, return error code in B
                    sec
                    rts
?SetBAUD.SetBaud    lda       1,x                 ;get MCU bps rate value
                    clr       SCCR2               ;disable SCI while changing BAUD
                    sta       BAUD
                    clr       SCCR1
                    lda       #%1100              ;No interrupt mode RX/TX
                    sta       SCCR2
                    clc                           ;no error exit
                    rts

; Purpose: Print constant ASCIZ string following OS instruction (with FCS)
; Parms  : None
?Print              ldx       PC_,y               ;get address following OS
?Print.Loop         lda       ,x                  ;get character to print
                    beq       ?Print.Exit         ;at the end of ASCIZ string, exit
                    bsr       ?PutChar.Local      ;send the character to SCI
                    inx                           ;point to next character
                    bne       ?Print.Loop         ;avoids infinite loops
?Print.Exit         inx                           ;point after NUL
                    stx       PC_,y               ;..to use as return address
                    clc                           ;no errors
                    rts

; Purpose: Read SCI char, is present, into RegA
; Output : A holds character if Carry Clear
;        : Carry set if character not available
?GetPossibleChar    lda       SCSR                ;wait for character waiting
                    anda      #$20
                    beq       ?GetPossibleChar.No
                    lda       SCDR                ;read character
                    sta       A_,y
                    clc                           ;never an error from here
                    rts
?GetPossibleChar.No ldb       B_,y                ;avoid destroying original B
                    sec
                    rts

; Purpose: Read SCI char into RegA
; Output : A holds character
?GetChar            lda       SCSR                ;wait for character waiting
                    anda      #$20
                    beq       ?GetChar
                    lda       SCDR                ;read character
                    sta       A_,y
                    clc                           ;never an error from here
                    rts

; Purpose: Write RegA character to the SCI
; Input  : A holds character
?PutChar            lda       A_,y
?PutChar.Local      tst       SCSR                ;wait for ready to TX
                    bpl       ?PutChar.Local
                    sta       SCDR                ;send character
                    clc                           ;never an error from here
                    rts

; Purpose: Write (send) a string to the SCI
; Input  : X->buffer of Pascal-like string, ie., LengthByte,Char1,Char2,...
; Note(s): buffer should not be used for incoming chars, for it will be
;          messed up.
?Write              ldx       X_,y
                    ldy       #REGS
                    ldb       ,x                  ;get length of string
                    beq       ?Write.NoError      ;if 0, nothing to send
?Write.Loop         inx                           ;point to data
                    lda       ,x
                    bsr       ?PutChar.Local
                    decb
                    bne       ?Write.Loop
?Write.NoError      clc
                    rts

; Purpose: Writeln (send) a string to the SCI followed by a CR,LF pair
; Input  : X->buffer of Pascal-like string, ie., LengthByte,Char1,Char2,...
?Writeln            bsr       ?Write              ;do regular fWrite
                    bcs       ?Writeln.Exit       ;on failure, exit
; Purpose: Advance a line sending a CR,LF pair to the SCI
?NewLine            lda       #CR                 ;send a CR
                    bsr       ?PutChar.Local
                    lda       #LF                 ;send a LF
                    bsr       ?PutChar.Local
                    clc
?Writeln.Exit       rts

; Purpose: Write (send) a string to the SCI
; Input  : X->ASCIZ string, ie., Char1,Char2,...,0
; Note(s): buffer should not be used for incoming chars, for it will be
;          messed up.
?WriteZ             ldx       X_,y
?WriteZ.Loop        lda       ,x
                    beq       ?WriteZ.NoError
                    bsr       ?PutChar.Local
                    inx
                    bne       ?WriteZ.Loop        ;avoids infinite loops
                    ldb       #errOutOfRange      ;on memory wrap-around
                    sec
                    rts
?WriteZ.NoError     clc
                    rts

; Purpose: Writeln (send) a string to the SCI followed by a CR,LF pair
; Input  : X->ASCIZ string, ie., Char1,Char2,...,0
?WritelnZ           bsr       ?WriteZ             ;do regular fWriteZ
                    bcs       ?Writeln.Exit       ;on failure, exit
                    bra       ?NewLine

#ifmain
                    #include  DISPATCH.MOD
#endif
                    #ROM