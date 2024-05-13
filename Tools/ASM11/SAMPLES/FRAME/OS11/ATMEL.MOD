;**********************************************************************
;* Module    : ATMEL.MOD
;* Programmer: Tony Papadimitriou
;* Purpose   : Atmel FLASH/EEPROM related OS-called routines
;* Language  : MC68HC11 (ASM11 v1.85+)
;* Status    : Copyright (c) 1999 by Tony Papadimitriou
;* Segments  : ROM    : Code
;*           : SEG9   : OS definitions (this allows adding more functions)
;* Note(s)   : All routines first copy themselves to stack RAM,
;*           : then execute from there.  For this reason a sufficient
;*           : amount of stack space must be available before entry.
;*           : Roughly about 180 bytes are needed just for the code itself
;*           : not counting stack required for execution.
;* History   : 99.12.07 v1.00 Original
;*           : 99.12.14 v1.01 Added delay in SDP_On/PD_Off
;*           : 99.12.15 v1.02 Corrected fBlockWriteAtmel to actually run from RAM
;*           : 99.12.16 v1.03 Minor optimizations
;*           : 99.12.17 v1.04 Minor optimizations/fixes
;**********************************************************************

#ifmain
                    #LISTOFF
                    #INCLUDE  811E2.INC
                    #INCLUDE  COMMON.INC
                    #INCLUDE  OS11/OSERRORS.INC
                    #LISTON

                    #SEG9
                    ORG       $FF00
#endif

?$5555              EQU       $D555               ;change to 5555 if using lower 32K
?$2AAA              EQU       $AAAA               ;change to 2AAA if using lower 32K
?DELAY              EQU       3333                ;Delay constant for 10msec at 2MHz E

?SECTOR_SIZE        EQU       64                  ;DO NOT CHANGE; bytes per sector

                    #SEG9
#ifndef OSCommands
OSCommands          equ       *
#endif

fBlockWriteAtmel    equ       *-OSCommands/2      ;Write EEPROM bytes using block mode
                    dw        ?BlockWriteAtmel

fWriteAtmel         equ       *-OSCommands/2      ;Write one EEPROM byte
                    dw        ?WriteAtmel

fEraseAtmel         equ       *-OSCommands/2      ;Erase one EEPROM byte
                    dw        ?EraseAtmel

fSDP_On             equ       *-OSCommands/2      ;Software Data Protection On
                    dw        ?SDP_On

fSDP_Off            equ       *-OSCommands/2      ;Software Data Protection Off
                    dw        ?SDP_Off

fBulkEraseAtmel     equ       *-OSCommands/2      ;Bulk Erase EEPROM
                    dw        ?BulkEraseAtmel

#PAGE ;Operating System routines expanded
**********************************************************************
*                 Operating System routines expanded                 *
**********************************************************************
                    #ROM

;********************************************************************
; THE FOLLOWING CODE SECTION IS FIRST COPIED TO RAM, THEN EXECUTED
;********************************************************************
?RAM                pshb
                    ldb       #$AA                ;Load $AA to $5555
                    stb       ?$5555
                    comb                          ;Load $55 to $2AAA
                    stb       ?$2AAA
                    ldb       #$A0                ;Load $A0 to $5AAA
                    stb       ?$5555
                    pulb
                    sta       ,x                  ;write actual value to program
                    pshy
                    ldy       #?DELAY             ;Delay at most ~10 msec or until read value is verified
?RAM.Loop           cmpa      ,x                  ;if WRITTEN=READ then
                    beq       ?RAM.Exit           ;  exit
                    dey                           ;else Dec(Y)
                    bne       ?RAM.Loop           ;  if Y <> 0 then goto ?RAM.Loop
                    puly
                    sec                           ;Failure
                    rts
?RAM.Exit           puly
                    clc                           ;Success
                    rts

?Chip_Erase         pshb
                    ldb       #$AA                ;Load $AA to $5555
                    stb       ?$5555
                    comb                          ;Load $55 to $2AAA
                    stb       ?$2AAA
                    ldb       #$80                ;Load $80 to $5AAA
                    stb       ?$5555
                    ldb       #$AA                ;Load $AA to $5555
                    stb       ?$5555
                    comb                          ;Load $55 to $2AAA
                    stb       ?$2AAA
                    ldb       #$10                ;Load $10 to $5AAA
                    stb       ?$5555
                    pulb
?Delay10            pshx
                    ldx       #?DELAY             ;Delay 10 msec
                    dex
                    bne       *-1
                    pulx
                    rts

?SDP_Off.Delayed    bsr       ?SDP_Off.Local
                    bra       ?Delay10

?SDP_Off.Local      pshb
                    ldb       #$AA                ;Load $AA to $5555
                    stb       ?$5555
                    comb                          ;Load $55 to $2AAA
                    stb       ?$2AAA
                    ldb       #$80                ;Load $80 to $5AAA
                    stb       ?$5555
                    ldb       #$AA                ;Load $AA to $5555
                    stb       ?$5555
                    comb                          ;Load $55 to $2AAA
                    stb       ?$2AAA
                    ldb       #$20                ;Load $20 to $5AAA
                    stb       ?$5555
                    pulb
                    rts

?SDP_On.Delayed     bsr       ?SDP_On.Local
                    bra       ?Delay10

?SDP_On.Local       pshb
                    ldb       #$AA                ;Load $AA to $5555
                    stb       ?$5555
                    comb                          ;Load $55 to $2AAA
                    stb       ?$2AAA
                    ldb       #$A0                ;Load $A0 to $5AAA
                    stb       ?$5555
                    pulb
                    rts

?BlockWriteAtmel.L  lda       #?SECTOR_SIZE       ;reset counter
?BlockWriteAtmel.A  sta       ?secbytes,X
                    jsr       ?SDP_On.Local-?RAM,X ;call SDP ON routine
?BlockWriteAtmel.S  ldy       ?Y,X                ;Y -> source
                    lda       ,Y                  ;A[Y] := source byte
                    iny
                    sty       ?Y,X                ;Inc(Y)
                    ldy       ?X,X                ;Y -> destination
                    sta       ,Y                  ;destination := A[Y]
                    iny
                    sty       ?X,X                ;Inc(Y)
                    ldd       ?D,X                ;D := counter
                    decd                          ;Dec(D)
                    std       ?D,X
                    beq       ?Delay10            ;if D = 0 then exit with final delay
                    dec       ?secbytes,X
                    bne       ?BlockWriteAtmel.S
                    bsr       ?Delay10            ;wait for block to be written
                    bra       ?BlockWriteAtmel.L

?RAM_Needed         equ       *-?RAM

;********************************************************************
                    #push
                    #mapoff
; IN: X -> destination RAM after GETX #?? (everything else is known)
; On exit, it turn ints off assuming next action is call to subroutine
?Copy               pshd                          ;save used registers
                    pshx
                    pshy
                    ldy       #?RAM               ;Y -> source
                    ldb       #?RAM_Needed
?Copy.Loop          lda       ,y                  ;copy source byte
                    sta       ,x                  ;  to destination
                    inx                           ;bump up destination
                    iny                           ;  and source pointers
                    decb                          ;one less byte to copy
                    bne       ?Copy.Loop          ;repeat until done
                    puly                          ;restore registers
                    pulx
                    puld
                    sei                           ;no ints allowed
                    rts
                    #pull

; Write bytes starting at specified address using block mode
; IN: X -> destination
;   : Y -> source
;   : D -> block length
?D                  equ       ?RAM_Needed         ;Word
?X                  equ       ?RAM_Needed+2       ;Word
?Y                  equ       ?RAM_Needed+4       ;Word
?secbytes           equ       ?RAM_Needed+6       ;Byte
?BlockWriteAtmel    ldd       D_,Y
                    beq       ?BlockWriteAtmel.Ex ;exit on zero
                    xgab                          ;put A,B in correct order

                    getx      #?RAM_Needed+7      ;allocate temp storage
                    bsr       ?Copy
                    std       ?D,X                ;Save D (byte counter)
                    ldd       Y_,Y
                    std       ?Y,X                ;Save Y (source pointer)
                    ldd       X_,Y
                    std       ?X,X                ;Save X (destination pointer)
                    andb      #?SECTOR_SIZE-1     ;mask to determine 1st sector bytes
                    lda       #?SECTOR_SIZE
                    sba                           ;A := ?SECTOR_SIZE - (X & (?SECTOR_SIZE-1))
                    bne       ?BlockWriteAtmel.J  ;if zero, then
                    lda       #?SECTOR_SIZE       ;  reset to full block write
?BlockWriteAtmel.J  jsr       ?BlockWriteAtmel.A-?RAM,X ;on entry A holds remaining 1st sector bytes
                    givex     #?RAM_Needed+7      ;de-allocate temp storage

?BlockWriteAtmel.Ex clc                           ;never an error from here
                    rts

; Write a byte at specified address
; IN: X -> address
;   : A = byte to program
?WriteAtmel         getx      #?RAM_Needed        ;allocate temp storage
                    bsr       ?Copy

                    pshy
                    lda       A_,Y
                    ldy       X_,Y
                    xgxy                          ;X->stack, Y->routine
                    jsr       ,Y                  ;call routine
                    puly

                    tpa
                    ldb       B_,Y                ;get caller's B (just in error case)
                    givex     #?RAM_Needed        ;de-allocate temp storage
                    tap
                    rts

?EraseAtmel         getx      #?RAM_Needed        ;allocate temp storage
                    bsr       ?Copy

                    pshy
                    lda       #$FF
                    ldy       X_,Y
                    xgxy                          ;X->stack, Y->routine
                    jsr       ,Y                  ;call routine
                    puly

                    tpa
                    ldb       B_,Y                ;get caller's B (just in error case)
                    givex     #?RAM_Needed        ;de-allocate temp storage
                    tap
                    rts

?BulkEraseAtmel     getx      #?RAM_Needed        ;allocate temp storage
                    jsr       ?Copy
                    jsr       ?Chip_Erase-?RAM,X  ;call routine
?Common_Exit        givex     #?RAM_Needed        ;de-allocate temp storage
                    clc                           ;never an error from here
                    rts

?SDP_Off            getx      #?RAM_Needed        ;allocate temp storage
                    jsr       ?Copy
                    jsr       ?SDP_Off.Delayed-?RAM,X
                    bra       ?Common_Exit

?SDP_On             getx      #?RAM_Needed        ;allocate temp storage
                    jsr       ?Copy
                    jsr       ?SDP_On.Delayed-?RAM,X
                    bra       ?Common_Exit
#ifmain
                    #push
                    #mapoff
                    #listoff
                    #include  OS11/DISPATCH.MOD
                    #pull
#endif