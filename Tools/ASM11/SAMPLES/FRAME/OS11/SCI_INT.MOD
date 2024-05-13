;**********************************************************************
;* Module    : SCI_INT.MOD
;* Programmer: Tony Papadimitriou
;* Purpose   : Interrupt-driven SCI RX and TX OS-called routines
;* Language  : MC68HC11 (ASM11 v1.83+)
;* Status    : FREEWARE, Copyright (c) 1999 by Tony Papadimitriou
;* Segments  : RAM    : Variables
;*           : ROM    : Code
;*           : SEG9   : OS definitions (this allows adding more functions)
;*           : VECTORS: SCI vector
;* Subsystems: Makes use of SCI interrupts
;* History   : 99.11.12 v1.00 Original (Started on 99.11.12)
;*           : 99.11.12 v1.01 Added fGetChar
;*           : 99.11.27 v1.02 Added fGetPossibleChar (doesn't wait for char)
;**********************************************************************

#ifmain ;---------- allows for separate compilation -------------------
                    #LISTOFF
                    #INCLUDE  811E2.INC
                    #INCLUDE  COMMON.INC
                    #INCLUDE  OS11/OSERRORS.INC
                    #LISTON

                    #SEG9
                    ORG       $FF00
#endif
                    #RAM
?MAXBUF             EQU       16                  ;RX and TX buffer lengths

; zero RX.index or TX.index indicates empty buffer

?RX.index           rmb       1                   ;offset into RX buffer
?RX.buffer          rmb       ?MAXBUF             ;buffer for received characters

?TX.index           rmb       1                   ;offset into TX buffer
?TX.buffer          rmb       ?MAXBUF             ;buffer for characters to transmit

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
?UsrErrorJump       os        fPrint              ;print standard error header
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
                    lda       #%00101100          ;Interrupt RX and TX mode
                    sta       SCCR2
; Clear the buffer to be used for transmission/receipt of data
                    ldx       #?RX.index          ;get pointer to beginning of vars
                    ldb       #?MAXBUF+1*2        ;get length for both buffers and indices
?SetBAUD.Loop       clr       ,x                  ;clear buffer
                    inx                           ;advance pointer
                    decb                          ;one less to go
                    bne       ?SetBAUD.Loop       ;repeat until done
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
?GetPossibleChar    ldx       #?RX.index
                    sei
                    jsr       ?DeQ
                    brset     CCR_,y,I.,?GetPChar.NoInt
                    cli
?GetPChar.NoInt     bcs       ?GetPChar.Zero      ;check if zero
?GetPChar.OK        sta       A_,y
                    clc                           ;never an error from here
                    rts
?GetPChar.Zero      tsta
                    bne       ?GetPChar.OK        ;other it was last char
                    ldb       B_,y                ;avoid destroying original B
                    sec
                    rts


; Purpose: Read SCI char into RegA
; Output : A holds character
?GetChar            ldx       #?RX.index
                    sei
                    bsr       ?DeQ
                    brset     CCR_,y,I.,?GetChar.NoInt
                    cli
?GetChar.NoInt      bcs       ?GetChar.Zero       ;check if zero
?GetChar.OK         sta       A_,y
                    clc                           ;never an error from here
                    rts
?GetChar.Zero       tsta
                    beq       ?GetChar            ;if zero, wait for char
                    bra       ?GetChar.OK         ;other it was last char

; Purpose: Write RegA character to the SCI
; Input  : A holds character
?PutChar            lda       A_,y
?PutChar.Local      pshx
                    ldx       #?TX.index          ;point to TX buffer
?PutChar.Loop       sei
                    bsr       ?EnQ                ;attempt to enqueue char
                    brset     CCR_,y,I.,?PutChar.NoInt
                    cli
?PutChar.NoInt      bcs       ?PutChar.Loop       ;wait if not ready yet
                    bsr       ?TXEnable           ;now, tell TCs can start working again
                    pulx
                    clc                           ;never an error from here
                    rts

; Purpose: Write (send) a string to the SCI
; Input  : X->buffer of Pascal-like string, ie., LengthByte,Char1,Char2,...
; Note(s): buffer should not be used for incoming chars, for it will be
;          messed up.
?Write              ldx       X_,y
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

; EnQueue character in RegA to buffer pointed by X (RX.buffer or TX.buffer)
?EnQ                pshb
                    ldb       ,x                  ;B := index
                    incb                          ;index := index + 1
                    cmpb      #?MAXBUF            ;if index > ?MAXBUF then
                    bhi       ?Q.Error            ;  buffer full, exit
                    stb       ,x                  ;save updated index
                    pshx
                    abx                           ;point to buffer[index]
                    sta       ,x                  ;and save character
                    pulx
                    pulb
                    clc
                    rts

?Q.Error            pulb                          ;common for ?EnQ and ?DeQ
?Q.Error1           sec
                    rts

; DeQueue in RegA a character from buffer pointed by X (RX.index or TX.index)
?DeQ                clra                          ;in case of error, A := NUL
                    tst       ,x                  ;if index = 0 then
                    beq       ?Q.Error1           ;  exit with error
                    lda       1,x                 ;A := buffer[1] (always return the first char)
?Q.Shrink           pshx
                    pshd
                    ldb       ,x                  ;get new length
                    dec       ,x                  ;decrement buffer length
?Q.Shrink.Loop      decb
                    beq       ?Q.Shrink.Exit
                    lda       2,x                 ;get next character
                    sta       1,x                 ;into current character
                    inx
                    bra       ?Q.Shrink.Loop
?Q.Shrink.Exit      puld
                    pulx
                    tst       ,x                  ;if new index = 0 then
                    beq       ?Q.Error1           ;  exit with error
                    clc
                    rts

; Enable TX interrupts
?TXEnable           psha
                    lda       SCCR2
                    ora       #TDRF.
                    sta       SCCR2
                    pula
                    rts

; SCI-related interrupt requests come here
SCI_Handler         lda       SCSR                ;get status to determine cause of interrupt
                    psha                          ;save it for later
                    bita      #$20                ;Anything received?
                    beq       SCI_Transmit        ;No, check TC flag

                    lda       SCDR                ;get received character
                    ldx       #?RX.index
                    bsr       ?EnQ                ;put character in RX queue
                    bcs       SCI_Exit            ;if save not possible, exit

SCI_Transmit        pula                          ;restore SCSR status in A
                    bita      #TDRF.              ;SCDR empty?
                    beq       SCI_Exit1           ;no, get out

                    ldx       #?TX.index          ;point to string
                    bsr       ?DeQ                ;get a character from TX queue
                    bcc       SCI_Exit2           ;not done yet, leave TC ints active
                    tsta                          ;if A <> 0, send then exit
                    beq       SCI_DisableTX
                    sta       SCDR                ;send it (clearing TC flag)
SCI_DisableTX       lda       SCCR2               ;on empty queue...
                    anda      #NOT^TDRF.
                    sta       SCCR2               ;terminate further ints
SCI_Exit1           rti                           ;exit without stack adjustment
SCI_Exit2           sta       SCDR                ;send it (clearing TC flag)
                    rti

SCI_Exit            ins                           ;adjust the stack for saved SCSR
                    rti                           ;then exit

#ifmain
                    #include  OS11/DISPATCH.MOD
#endif
                    #VECTORS
?vectors            equ       *

                    org       $FFD6
                    dw        SCI_Handler

                    org       ?vectors

                    #ROM

                    end