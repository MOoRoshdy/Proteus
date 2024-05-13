;**********************************************************************
;* Module    : EEPROM.MOD
;* Programmer: Tony Papadimitriou
;* Purpose   : Various OS-called routines
;* Language  : MC68HC11 (ASM11 v1.83+)
;* Status    : FREEWARE, Copyright (c) 1999 by Tony Papadimitriou
;* Segments  : RAM    : Variables
;*           : ROM    : Code
;*           : SEG9   : OS definitions (this allows adding more functions)
;* History   : 99.10.31 v1.00 Original (copied from 99.10.26 OS11.MOD)
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

fDelay10MS          equ       *-OSCommands/2      ;Delay 10ms
                    dw        ?Delay10MS

fWriteEE            equ       *-OSCommands/2      ;Write one EEPROM byte
                    dw        ?WriteEE

fEraseEE            equ       *-OSCommands/2      ;Erase one EEPROM byte
                    dw        ?EraseEE

fBulkEraseEE        equ       *-OSCommands/2      ;Bulk Erase EEPROM
                    dw        ?BulkEraseEE

#PAGE ;Operating System routines expanded
**********************************************************************
*                 Operating System routines expanded                 *
**********************************************************************
                    #ROM

; Purpose: Delay 10 msec (20000 cycles @500nsec/cycle assuming 2MHz E clock)
; Note(s): All involved registers are preserved so it can be called internally
;          This routine executes in 19999 cycles from entry (including BSR or
;          JSR instruction) to completion of RTS
?Delay10MS          pshx                          ;4 cycles
#ifdef DEBUG
                    ldx       #1                  ;for Simulator use minimum delay
#else
                    ldx       #3329               ;3 cycles
#endif
                    dex                           ;3 cycles
                    bne       *-1                 ;3 cycles
                    pulx                          ;5 cycles
                    clc                           ;2 cycles
                    rts                           ;5 cycles

; Purpose: Program an internal EEPROM location
; Input  : A_,y->value to be programmed
;        : X_,y->address to program
?WriteEE            lda       A_,y
                    ldx       X_,y
?WriteEE.Local      equ       *                   ;local call entry point
                    cmpa      ,x                  ;is it already programmed?
                    beq       ?WriteEE.Exit       ;yes, no need to program it
                    psha
                    bsr       ?EraseEE.Local      ;erase previous contents
                    pula
                    ldb       #$02                ;EELAT = 1
                    stb       PPROG               ;Set EELAT bit
                    sta       ,x                  ;save data to address
                    incb                          ;EELAT = 1 and EPGM = 1
                    stb       PPROG               ;Turn on programming voltage
                    bsr       ?Delay10MS          ;Delay 10 msec
                    clr       PPROG               ;Turn off programming voltage
                    cmpa      ,x                  ;Compare with value written
                    beq       ?WriteEE.Exit       ;if equal, get out, no errors
                    ldb       #errFailure
                    sec
                    rts
?WriteEE.Exit       clc
                    rts

; Purpose: Byte Erase an internal EEPROM location
; Input  : X_,y->address to erase
?EraseEE            ldx       X_,y
?EraseEE.Local      lda       #[ERASED_STATE      ;get the erased state for comparison
                    cmpa      ,x                  ;is it already erased?
                    beq       ?EraseEE.Exit       ;yes, no need to erase
                    ldb       #$16                ;BYTE = 1, ERASE = 1, EELAT = 1
                    stb       PPROG
                    stb       ,x                  ;any data to this address will do
                    incb                          ;BYTE = 1, ERASE = 1, EELAT = 1, EPGM = 1
                    stb       PPROG               ;Turn on programming voltage
                    bsr       ?Delay10MS          ;Delay 10 msec
                    clr       PPROG               ;Turn off programming voltage
                    cmpa      ,x                  ;is it erased ($FF)?
                    beq       ?EraseEE.Exit       ;if equal, get out, no errors
                    ldb       #errFailure
                    sec
                    rts
?EraseEE.Exit       clc
                    rts

; Purpose: Bulk Erase EEPROM
?BulkEraseEE        ldb       #$06                ;EELAT = 1
                    stb       PPROG
                    sta       EEPROM              ;any EEPROM address will do
                    incb                          ;EELAT = 1 and EPGM = 1
                    stb       PPROG               ;Turn on programming voltage
                    bsr       ?Delay10MS          ;Delay 10 msec
                    clr       PPROG               ;Turn off programming voltage
                    ldx       #EEPROM             ;Check if all EEPROM is erased
                    ldd       #ERASED_STATE       ;Value for erased words
?BulkEraseEE.Check  cmpd      ,x                  ;Is word at ,X erased?
                    bne       ?BulkEraseEE.Error  ;No, get out with error
                    inx:2                         ;Yes, get ready for next word
                    cmpx      #EEPROM_END         ;At the end of EEPROM?
                    blo       ?BulkEraseEE.Check  ;No, let's do it again
                    clc                           ;Yes, no errors encountered
                    rts
?BulkEraseEE.Error  ldb       #errFailure
                    sec
                    rts

#ifmain
                    #include  DISPATCH.MOD
#endif
                    #ROM
