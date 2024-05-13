;**********************************************************************
;* Module    : MISC.MOD
;* Programmer: Tony Papadimitriou
;* Purpose   : Miscellaneous OS-called routines
;* Language  : MC68HC11 (ASM11 v1.83+)
;* Status    : FREEWARE, Copyright (c) 1999 by Tony Papadimitriou
;* Segments  : RAM    : Variables
;*           : ROM    : Code
;*           : SEG9   : OS definitions (this allows adding more functions)
;* History   : 99.10.31 v1.00 Original (copied from 99.10.26 OS11.MOD)
;*           : 99.11.22 v1.01 Added fHexToBin
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

fCopyMem            equ       *-OSCommands/2      ;Copy a block of memory
                    dw        ?CopyMem

fBin2Dec            equ       *-OSCommands/2      ;Binary to Decimal conversion
                    dw        ?Bin2Dec

fBin2BCD            equ       *-OSCommands/2      ;Binary to BCD conversion (actually any base)
                    dw        ?Bin2BCD

fSearchTable        equ       *-OSCommands/2      ;Search any data table
                    dw        ?SearchTable

fConvertAD          equ       *-OSCommands/2      ;Convert A/D value to volts
                    dw        ?ConvertAD

fKickCOP            equ       *-OSCommands/2      ;Kick the COP timer to prevent timeout resets
                    dw        KickCOP             ;Not a local label, called either way

fHexToASCII         equ       *-OSCommands/2      ;Convert a hex number to its ASCII equivalent
                    dw        ?HexToASCII

fReverseByte        equ       *-OSCommands/2      ;Reverse a byte's bit order from MSB to LSB or back
                    dw        ?ReverseByte

fGetBootMode        equ       *-OSCommands/2      ;Get the boot mode code
                    dw        ?GetBootMode

fIncBCD             equ       *-OSCommands/2      ;Increment a BCD number
                    dw        ?IncBCD

fDecBCD             equ       *-OSCommands/2      ;Decrement a BCD number
                    dw        ?DecBCD

fHexToBin           equ       *-OSCommands/2      ;Convert a hex number to binary
                    dw        ?HexToBin

#PAGE ;Operating System routines expanded
**********************************************************************
*                 Operating System routines expanded                 *
**********************************************************************
                    #ROM

?Op_Unused          ldb       #errUnused          ;Dummy call for missing opcodes
                    sec                           ;..use your own non-zero error codes
AnRTS               rts                           ;Also, provides a globally accessed RTS

; Purpose: Copy (move) bytes from source to destination memory
; Input  : D holds number of bytes to copy
;        : Y points to start of source memory
;        : X points to start of destination memory
; Note(s): Correctly handles copies (even partially) to EEPROM
?CopyMem            pshy
                    lda       A_,y                ;load parameters
                    ldb       B_,y
                    ldx       X_,y
                    ldy       Y_,y
                    cmpd      #0                  ;any bytes to copy?
                    beq       ?CopyMem.NoError    ;no, get out of here
?CopyMem.Loop       pshd                          ;save counter between loops
#ifdef fWriteEE
                    cpx       #EEPROM             ;check destination for EEPROM
                    blo       ?CopyMem.RAM
                    cpx       #EEPROM_END
                    bhi       ?CopyMem.RAM
     ;?CopyMem.EEPROM
                    lda       ,y                  ;get a byte from source
                    os        fWriteEE            ;write EEPROM byte A to ,X
                    bcs       ?CopyMem.Error      ;on error...
                    bra       ?CopyMem.LoopEnd    ;no error, continue
#endif
?CopyMem.RAM        lda       ,y                  ;get byte from source
                    sta       ,x                  ;put byte to destination
?CopyMem.LoopEnd    inx                           ;bump up both pointers
                    iny
                    puld                          ;get loop counter
                    decd                          ;and count down
                    bne       ?CopyMem.Loop
?CopyMem.NoError    puly
                    clc
                    rts
?CopyMem.Error      puld
                    puly
                    ldb       #errFailure
                    sec
                    rts

; Purpose: Convert a binary number to decimal
; Input  : D=Unsigned binary number from 0 to 65535 ($FFFF)
; Output : D=First two ASCII digits of result (first char is blank)
;        : X=Second two ASCII digits of result
;        : Y=Third two ASCII digits of result
?Bin2Dec            lda       A_,y
                    ldb       B_,y
                    ldx       #'00'
                    pshx:3                        ;initialize stack result
                    tsx                           ;and put it's pointer in Y
                    inx:2
?Bin2Dec.01.0       subd      #10000              ;figure out tens of thousands
                    bcs       ?Bin2Dec.01
                    inc       1,x                 ;increment tens of thousands
                    bra       ?Bin2Dec.01.0
?Bin2Dec.01         addd      #10000
?Bin2Dec.01.1       subd      #1000               ;figure out thousands
                    bcs       ?Bin2Dec.02
                    inc       2,x                 ;increment thousands
                    bra       ?Bin2Dec.01.1
?Bin2Dec.02         addd      #1000
?Bin2Dec.02.1       subd      #100
                    bcs       ?Bin2Dec.03
                    inc       3,x                 ;increment hundreds
                    bra       ?Bin2Dec.02.1
?Bin2Dec.03         addd      #100
?Bin2Dec.03.1       subb      #10                 ;no need to use D anymore
                    bcs       ?Bin2Dec.04
                    inc       4,x                 ;increment tens
                    bra       ?Bin2Dec.03.1
?Bin2Dec.04         addb      #10+'0'             ;no need to use D anymore
                    stb       5,x                 ;finally, save units
                    puld
                    sta       A_,y
                    stb       B_,y
                    pulx
                    stx       X_,y
                    pulx
                    stx       Y_,y
?Bin2Dec.Exit       clc
                    rts

; Purpose: Convert a binary word value to BCD or other base
; Input  : D holds word value
;        : X points to output buffer
;        : Y holds length of buffer
;        : First byte of buffer holds conversion base
; Note(s): Although user's stack frame is used for temporary storage,
;        : it is left intact.
?Bin2BCD            equ       *
          ; save original stack frame
                    ldx       Y_,y                ;Save stack frame's Y
                    pshx
                    ldx       X_,y                ;Save stack frame's X (pointer to buffer)
                    pshx
          ; check conversion base for validity
                    clra                          ;Get conversion base in D
                    ldb       ,x
                    cmpb      #2                  ;Check base to be 2 to 36
                    blo       ?Bin2BCD.Error
                    cmpb      #36
                    bhi       ?Bin2BCD.Error
          ; make buffer pointer point to end of buffer (last character)
                    xgdx                          ;Now X holds base, D holds buffer pointer
                    addd      Y_,y                ;add length of buffer
                    decd                          ;minus 1 to point to end of buffer
                    std       X_,y                ;and save in temp space

                    lda       A_,y                ;Load D register with word
                    ldb       B_,y                ;..to convert
                    pshx                          ;push needed for first pass of next loop

?Bin2BCD.01         pulx
                    pshx
                    idiv                          ;X should be holding base here
                    jsr       ToDigit

          ; save current digit to buffer and adjust buffer pointer backwards
                    pshx
                    ldx       X_,y                ;Point to current buffer character
                    stb       ,x                  ;Save remainder in output buffer
                    dex                           ;decrement pointer toward start of buffer
                    stx       X_,y                ;and save it
                    pulx

                    xgdx                          ;and use integer result as input for
                    dec       Y_+1,y              ;decrement [low byte] of Y counter
                    bne       ?Bin2BCD.01         ;2nd.last digit? if no, loop back
?Bin2BCD.Exit       pulx:2                        ;adjust stack and restore stack frame's X
                    stx       X_,y
                    pulx                          ;restore stack frame's Y
                    stx       Y_,y
                    clc
                    rts
?Bin2BCD.Error      pulx:2                        ;dummy PULLs to adjust stack
                    ldb       #errBadParm
                    sec
                    rts

; Purpose: Search a data table for some value, and return its index
;        : Table must be terminated with zero (byte or word) depending
;        : on target size
; Input  : B = number of bytes per entry (eg. 5)
;        : X points to beginning of table
;        : Y holds value to search for (if byte, lower 8-bits only)
;        : Carry Clear = Byte Search
;        : Carry Set   = Word Search
; Output : IF FOUND:     X points to matched table entry
;        :               B is unaffected
;        :               Carry Clear
;        : IF NOT FOUND: X is unaffected
;        :               B holds error code (errNotFound)
;        :               Carry Set
?SearchTable        ldb       B_,y                ;get size of entries in B
                    ldx       X_,y                ;get actual X value
                    brclr     CCR_,y,C.,?SearchTable.Byte ;go to the byte search part
?SearchTable.Loop   ldd       ,x                  ;get table value
                    beq       ?SearchTable.Fail   ;end-of-table, get out
                    cmpd      Y_,y                ;compare with word target
                    beq       ?SearchTable.Found  ;if equal, we found it!
                    ldb       B_,y                ;reload B with size of entries
                    abx                           ;point to next entry
                    bra       ?SearchTable.Loop   ;..and try again
?SearchTable.Found  stx       X_,y                ;save return result
;                   clc                           ;not really needed after BEQ true
                    rts
?SearchTable.Fail   ldb       #errNotFound
                    sec
                    rts
?SearchTable.Byte   lda       ,x                  ;get table value
                    beq       ?SearchTable.Fail   ;end-of-table, get out
                    cmpa      Y_+1,y              ;compare with byte target
                    beq       ?SearchTable.Found  ;if equal, we found it!
                    abx                           ;point to next entry
                    bra       ?SearchTable.Byte   ;..and try again

; Purpose: Convert an A/D reading (based on 5Volt Vrh-Vrl) to an ASCII
;        : string with the equivalent decimal number (10digits)
; Input  : X points to beginning of output buffer
;        : A holds A/D reading
; Output : Buffer pointed by X is filled with result
;        : Carry Clear
; Note(s): No registers are affected
?ConvertAD          ldx       X_,y                ;get actual X value
                    lda       A_,y                ;get actual A value
                    pshx
                    ldb       #9                  ;number of digits
                    pshb                          ;temporary byte for counter
                    tsy                           ;point to new stack frame
                    ldb       #5                  ;Scale to 5Volts
?Convert.Loop       mul
                    adda      #'0'
                    sta       1,x
                    inx
                    tba
                    ldb       #10
                    dec       ,y
                    bne       ?Convert.Loop
                    ins                           ;kill temp (faster than PULB)
                    pulx
                    lda       1,x
                    ldb       #'.'
                    std       ,x
                    clc                           ;never an error from here
                    rts

; Routine: KickCOP
; Purpose: Kick the COP timer (Call this to prevent COP timeout resets)
; Input  : None
; Output : None
; Note(s): Call either way: "OS fKickCOP" or "JSR KickCOP" (faster)
KickCOP             equ       *
#ifdef NOINTS
                    pshd                          ;save registers to be used
                    tpa                           ;keep copy of CCR
                    sei                           ;no IRQs during sequence
#else
                    pshb                          ;save registers to be used
#endif
                    ldb       #$55
                    stb       COPRST
                    comb
                    stb       COPRST
#ifdef NOINTS
                    tap                           ;restore CCR (re-enable IRQs?)
                    puld                          ;restore used registers
#else
                    pulb                          ;restore used registers
#endif
                    clc                           ;never an error from here
                    rts

; Routine: HexToASCII
; Purpose: Convert a hex number in lower A to ASCII equivalent in D
; Input  : A holds binary number (higher nibble is ignored)
; Output : D holds ASCII equivalent of number
?HexToASCII         lda       A_,y
                    anda      #$0F                ;kill higher nibble just in case
                    daa                           ;convert to BCD
                    tab                           ;make a copy in B
                    lsra:4                        ;transfer A to lower half
                    andb      #$0F                ;clear upper half of B
                    addd      #'00'               ;finally, convert to ASCII
                    sta       A_,y                ;save result for caller
                    stb       B_,y
?HexToASCII.Exit    clc                           ;never an error from this routine
                    rts

; Routine: ReverseByte
; Purpose: Reverse a byte's bit order from MSB to LSB or back
; Input  : A=byte whose bit order to change
; Output : A=byte with bit order changed
?ReverseByte        ldb       #8                  ;number of bits
                    clra                          ;start with zero RegA
?ReverseByte.Loop   lsr       A_,y                ;get right-most bit in Carry
                    rola                          ;get Carry in right-most RegA bit
                    decb                          ;one less bit to process
                    bne       ?ReverseByte.Loop   ;repeat for all bits
                    sta       A_,y                ;save result
                    clc                           ;never an error from here
                    rts

; Routine: GetBootMode
; Purpose: Reverse a byte's bit order from MSB to LSB or back
; Input  : None
; Output : A=byte with bits 1-0 indicating boot mode as follows:
;          %00=Single-Chip, %01=Expanded, %10=Bootstrap, %11=SpecialTest
;        : X -> string with ASCIZ message indicating mode
?GetBootMode        lda       HPRIO               ;Get current HPRIO contents
                    anda      #%01100000          ;Mask off unwanted bits
                    lsra:5                        ;Move mode bits to lsb
                    sta       A_,y                ;save result
                    beq       ?GetBootMode.00
                    cmpa      #%01
                    beq       ?GetBootMode.01
                    cmpa      #%10
                    beq       ?GetBootMode.10
                    ldx       #?BootMsg.11
                    bra       ?GetBootMode.Exit
?GetBootMode.10     ldx       #?BootMsg.10
                    bra       ?GetBootMode.Exit
?GetBootMode.01     ldx       #?BootMsg.01
                    bra       ?GetBootMode.Exit
?GetBootMode.00     ldx       #?BootMsg.00
?GetBootMode.Exit   stx       X_,Y
                    clc                           ;never an error from here
                    rts
?BootMsg.00         fcs       'Single-Chip'
?BootMsg.01         fcs       'Expanded'
?BootMsg.10         fcs       'Bootstrap'
?BootMsg.11         fcs       'Special Test'

; Routine: IncBCD
; Purpose: Increment a BCD number
; Input  : A=BCD number to increment
; Output : A=incremented BCD number
?IncBCD             lda       A_,y                ;Get value to increment
                    adda      #1                  ;increment it (Do NOT use INCA
                    daa                           ;or DAA won't work)
                    sta       A_,y                ;save it
                    clc                           ;never an error from here
                    rts

; Routine: DecBCD
; Purpose: Decrement a BCD number
; Input  : A=BCD number to decrement
; Output : A=decremented BCD number
?DecBCD             lda       A_,y                ;Get value to decrement
                    suba      #1                  ;decrement it (Do NOT use DECA
                    daa                           ;or DAA won't work)
                    sta       A_,y                ;save it
                    clc                           ;never an error from here
                    rts

; Routine: HexToBin
; Purpose: Convert a hex string to binary number
; Input  : D=hex string
; Output : A=binary equivalent
?HexToBin           lda       A_,Y
                    bsr       ?Upcase
                    bsr       ?HexToBin.Digit
                    lsla:4
                    sta       A_,Y
                    lda       B_,Y
                    bsr       ?Upcase
                    bsr       ?HexToBin.Digit
                    ora       A_,Y
                    sta       A_,Y
                    clc
                    rts
?HexToBin.Error     sec
                    rts
?HexToBin.Digit     cmpa      #'0'
                    blo       ?HexToBin.Error
                    cmpa      #'F'
                    bhi       ?HexToBin.Error
                    cmpa      #'9'
                    bls       ?HexToBin.Number
                    cmpa      #'A'
                    blo       ?HexToBin.Error
                    suba      #'A'-10-'0'
?HexToBin.Number    suba      #'0'
                    rts

#PAGE
*********************************************************************
*                     GENERAL-PURPOSE ROUTINES                      *
*********************************************************************

; Purpose: Convert a binary number to ASCII equivalent
; Input  : B holds binary number
; Output : B holds ASCII equivalent
ToDigit             addb      #'0'                ;convert to ASCII
                    cmpb      #'9'
                    bls       ?ToDigit.Exit
                    addb      #'A'-'0'-10         ;adjust for appropriate letter
?ToDigit.Exit       clc
                    rts

?Upcase             cmpa      #'a'
                    blo       ?Upcase.Exit
                    cmpa      #'z'
                    bhi       ?Upcase.Exit
                    suba      #'a'-'A'
?Upcase.Exit        rts

#ifmain
                    #include  DISPATCH.MOD
#endif
                    #ROM