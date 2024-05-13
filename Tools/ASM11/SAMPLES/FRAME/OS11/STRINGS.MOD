;**********************************************************************
;* Module    : STRINGS.MOD
;* Programmer: Tony Papadimitriou
;* Purpose   : String and character manipulation related OS-called routines
;* Language  : MC68HC11 (ASM11 v1.83+)
;* Status    : FREEWARE, Copyright (c) 1999 by Tony Papadimitriou
;* Segments  : RAM    : Variables
;*           : ROM    : Code
;*           : SEG9   : OS definitions (this allows adding more functions)
;* History   : 99.10.31 v1.00 Original (copied from 99.10.26 OS11.MOD)
;*           : 99.11.07 v1.01 Added fDeleteWord, fFillMem
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

fPos                equ       *-OSCommands/2      ;Get character position
                    dw        ?Pos

fFillMem            equ       *-OSCommands/2      ;Fill memory with character
                    dw        ?FillMem

fCompareBuf         equ       *-OSCommands/2      ;Compare buffers at X and Y
                    dw        ?Compare

fCompareStr         equ       *-OSCommands/2      ;Compare ASCIZ strings at X and Y
                    dw        ?CompareStr

fUpString           equ       *-OSCommands/2      ;Convert ASCIZ string to uppercase
                    dw        ?UpString

fUpPascalStr        equ       *-OSCommands/2      ;Convert Pascal-type string pointed to by X to uppercase
                    dw        ?UpPascalStr

fLength             equ       *-OSCommands/2      ;Get ASCIZ string length
                    dw        ?Length

fInsert             equ       *-OSCommands/2      ;Insert char within ASCIZ string
                    dw        ?Insert

fDelete             equ       *-OSCommands/2      ;Delete char within ASCIZ string
                    dw        ?Delete

fDeleteWord         equ       *-OSCommands/2      ;Delete chars until target char
                    dw        ?DeleteWord

fNoLeadChar         equ       *-OSCommands/2      ;Convert leading RegB chars to RegA char
                    dw        ?NoLeadChar

fGarble             equ       *-OSCommands/2      ;Garble buffer at X with seed in RegA
                    dw        ?Garble

#PAGE ;Operating System routines expanded
**********************************************************************
*                 Operating System routines expanded                 *
**********************************************************************
                    #ROM

; Purpose: Get the position of a character starting from X
; Input  : X points to beginning position in search buffer (0,CR,LF terminated)
;        : A holds character to search for
;        : B holds number of matches to perform
; Output : IF FOUND: B holds offset from X to found character (ready for ABX)
;        :           Carry is Clear
;        : IF NOT FOUND: B is unaffected and Carry is Set
; Note(s): Target character can also be one of the terminators
?Pos                ldx       X_,y                ;and load X
                    ldb       B_,y
                    beq       ?Pos.NotFound.Out   ;zero matches=not found
                    pshb                          ;save number of matches
                    clrb                          ;Initialize position counter
?Pos.Loop           lda       ,x                  ;get the buffer character
                    incb                          ;count this character
                    inx                           ;point to next buffer character
                    cmpa      A_,y                ;is it the same as the target?
                    beq       ?Pos.Found          ;if so, go count the match
                    tsta                          ;was it the end of the string
                    beq       ?Pos.NotFound       ;if so, we didn't find target
; next four lines can be commented if you wish to work with ASCIZ strings only
                    cmpa      #CR
                    beq       ?Pos.NotFound       ;A CR means end of string
                    cmpa      #LF
                    beq       ?Pos.NotFound       ;A LF means end of string
; previous four lines can be commented if you wish to work with ASCIZ strings only
                    bra       ?Pos.Loop           ;and try again
?Pos.NotFound       pulb                          ;rather than error code, return original B value
?Pos.NotFound.Out   sec                           ;indicates "not found"
                    rts
?Pos.Found          dec       B_,y                ;one less match to look for
                    bne       ?Pos.Loop           ;repeat until target match count
                    decb                          ;make counter zero-based (for ABX)
                    stb       B_,y                ;save result for user
                    ins                           ;de-allocate saved B (faster than PULB)
                    clc                           ;indicates "found"
                    rts

; Routine: FillMem
; Purpose: Fill memory buffer with given value
; Input  : X -> buffer
;        : A holds character
;        : B holds length
; Output : None
?FillMem            ldb       B_,y                ;get length
                    beq       ?FillMem.Exit       ;on zero length, exit
                    lda       A_,y                ;get character to fill with
                    ldx       X_,y                ;get buffer pointer
?FillMem.Loop       sta       ,x                  ;save char in buffer
                    inx                           ;point to next buffer char
                    decb                          ;one less to fill
                    bne       ?FillMem.Loop       ;repeat for all
?FillMem.Exit       clc                           ;never an error from here
                    rts

; Purpose: Compare buffers pointed by X and Y (case sensitive)
; Input  : B holds maximum number of bytes to compare
;        : X points to start of first memory
;        : Y points to start of second memory
; Output : N Z V C set or cleared in accordance with the CMP instruction
;        : Allows BEQ, BNE, BLO, BHS, etc. to be used on result just as if
;        : a regular CMPA instruction had been used.
; Note(s): All registers except N Z V C flags are preserved
;        : Violates Carry-Set on error rule.  Carry set is used for result (BLO, etc.)
?Compare            pshy
                    ldb       B_,y                ;load parameters
                    beq       ?Compare.OK         ;zero length always OK
                    ldx       X_,y
                    ldy       Y_,y
?Compare.Loop       lda       ,x                  ;get character at X
                    cmpa      ,y                  ;is the same as the one at Y?
                    bne       ?Compare.No         ;No, get out then
                    decb                          ;are we done with all characters?
                    beq       ?Compare.OK         ;Yes, and they all compare OK
                    inx                           ;No, let's go check next ones
                    iny
                    bra       ?Compare.Loop
?Compare.OK         clc                           ;Z flag always set when here, so CMP OK assumed
?Compare.No         pulx                          ;use X instead of Y for speed and size
                    tpa                           ;save CCR in A (actual CMP result)
                    psha
                    anda      #$0F                ;mask off unused flags
                    ldb       CCR_,x              ;get original CCR
                    andb      #$F0                ;mask off result bits
                    stb       CCR_,x              ;save it
                    ora       CCR_,x              ;combine with CMP results
                    sta       CCR_,x              ;and save final CCR
                    ldb       B_,x                ;get original B just in case carry is set
                    pula
                    tap                           ;restore local CCR
                    rts

; Purpose: Compare ASCIZ strings pointed by X and Y (case sensitive)
; Input  : X points to first ASCIZ string
;        : Y points to second ASCIZ string
; Output : N Z V C set or cleared in accordance with the CMP instruction
;        : Allows BEQ, BNE, BLO, BHS, etc. to be used on result just as if
;        : a regular CMPA instruction had been used.
; Note(s): All registers except N Z V C flags are preserved
;        : Violates Carry-Set on error rule.  Carry set is used for result (BLO, etc.)
?CompareStr         pshy
                    ldx       X_,y
                    ldy       Y_,y
?CompareStr.Loop    lda       ,x                  ;get character at X
                    cmpa      ,y                  ;is the same as the one at Y?
                    bne       ?Compare.No         ;No, get out then
                    tsta                          ;are we done with all characters?
                    beq       ?Compare.OK         ;Yes, and they all compare OK
                    inx                           ;No, let's go check next ones
                    iny
                    bra       ?CompareStr.Loop

; Purpose: Convert ASCIZ string pointed to by X to uppercase
; Input  : X_,y->string
; Output : X_,y->STRING
?UpString           ldx       X_,y                ;point X to string
?UpString.Loop      lda       ,x
                    beq       ?UpString.Exit
                    jsr       Upcase              ;convert to uppercase
                    sta       ,x
                    cpx       #RAM_END            ;do not run wild outside of RAM
                    bhs       ?UpString.Exit
                    inx
                    bne       ?UpString.Loop      ;avoids infinite loops
                    ldb       #errOutOfRange
                    sec
                    rts
?UpString.Exit      clc
                    rts

; Purpose: Convert Pascal-type string pointed to by X to uppercase
; Input  : X_,y->string
; Output : X_,y->STRING
?UpPascalStr        ldx       X_,y                ;point X to string
                    ldb       ,x                  ;get length in B
                    beq       ?UpPascalStr.Exit   ;get out now, if length is 0
?UpPascalStr.Loop   inx                           ;point to data byte
                    lda       ,x
                    jsr       Upcase              ;convert to uppercase
                    sta       ,x
                    decb
                    bne       ?UpPascalStr.Loop
?UpPascalStr.Exit   clc
                    rts

; Routine: Length
; Purpose: Get the length of an ASCIZ string
; Input  : X points to string
; Output : B holds length if Carry Clear, error "errOutOfRange" if Carry Set
; Note(s): Maximum string length is 255 characters
?Length             clrb
                    ldx       X_,y
?Length.Loop        tst       ,x
                    beq       ?Length.Exit
                    incb
                    beq       ?Length.Error       ;more than 255 is an error
                    inx
                    bne       ?Length.Loop        ;avoids infinite loops
?Length.Error       ldb       #errOutOfRange
                    sec
                    rts
?Length.Exit        stb       B_,y
                    clc
                    rts

; Routine: Insert
; Purpose: Insert a character within an ASCIZ string
; Input  : X points to string
;        : A holds character
;        : B holds position before which to insert
; Output : None
?Insert             lda       A_,y
                    ldb       B_,y
                    beq       ?Insert.Exit        ;Nothing to do, get out
                    ldx       X_,y
                    decb                          ;Make zero-based
                    abx
                    lda       ,x                  ;get first character
                    beq       ?Insert.End         ;are we done moving string up?
?Insert.Loop        ldb       1,x                 ;get next character
                    sta       1,x
                    inx                           ;go upstring
                    tba                           ;move next char to A
                    bne       ?Insert.Loop        ;repeat until A is zero
?Insert.End         sta       1,x                 ;save trailing zero
                    ldx       X_,y                ;now, add the character
                    lda       A_,y
                    ldb       B_,y
                    decb
                    abx
                    sta       ,x
?Insert.Exit        clc
                    rts

; Routine: Delete
; Purpose: Delete a character within an ASCIZ string
; Input  : X points to ASCIZ string
;        : B holds position to delete (first=1)
; Output : None
?Delete             ldb       B_,y
?Delete.Local       beq       ?Delete.Exit        ;Nothing to do, get out
                    ldx       X_,y
                    decb                          ;Make zero-based
                    abx
?Delete.Loop        tst       ,x                  ;check if at end-of-string
                    beq       ?Delete.Exit        ;are we done?
                    lda       1,x                 ;get next character
                    sta       ,x                  ;move down one place
                    inx                           ;go upstring
                    bne       ?Delete.Loop        ;repeat (avoids infinite loops)
?Delete.Exit        clc
                    rts

; Routine: DeleteWord
; Purpose: Delete chars until (and including) a certain char
; Input  : X points to ASCIZ string
;        : A holds target character (zero if for remaining string)
; Output : None
?DeleteWord         lda       A_,y                ;get target character
                    ldx       X_,y                ;point X to buffer
                    ldb       #1
                    cmpa      ,x                  ;is first character the target?
                    beq       ?DeleteWord.Exit    ;yes, go delete it and exit
                    bsr       ?Delete.Local       ;Delete first character
                    bra       ?DeleteWord         ;repeat (need to reload regs)
?DeleteWord.Exit    tsta                          ;to reset the zero flag
                    bsr       ?Delete.Local       ;Delete target character
                    clc
                    rts

; Routine: NoLeadChar
; Purpose: Convert leading RegB chars to RegA char
; Input  : A  Character to use for filling
;        : B  Character to be replaced
;        : X->Buffer area to change leading zeros to char in RegA
; Output : X->Buffer with leading RegB characters changed to RegA character
; Note(s): Terminates at first non-matching (RegB) character
?NoLeadChar         ldx       X_,y
                    lda       A_,y
                    ldb       B_,y
?NoLeadChar.Loop    cmpb      ,x
                    bne       ?NoLeadChar.Exit
                    sta       ,x                  ;replace with RegA character
                    inx
                    bne       ?NoLeadChar.Loop    ;avoids infinite loops
?NoLeadChar.Exit    clc
                    rts

; Routine: Garble
; Purpose: Garble buffer at X with seed in RegA
; Input  : X->buffer
;        : A=8-bit seed to use for garbling
;        : B=Length of buffer
; Output : Buffer at X is garbled with seed in RegA
?Garble             ldx       X_,y
                    ldb       B_,y
                    beq       ?Garble.Exit        ;no more bytes to process
?Garble.Loop        lda       ,x                  ;get character
                    eora      A_,y                ;XOR with user seed
                    sta       ,x                  ;put character back in buffer
                    inx                           ;point to next character
                    decb                          ;are we done with all chars?
                    bne       ?Garble.Loop
?Garble.Exit        clc
                    rts

#ifmain
                    #include  DISPATCH.MOD
#endif
                    #ROM