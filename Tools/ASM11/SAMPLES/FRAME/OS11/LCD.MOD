;**********************************************************************
;* Module    : LCD.MOD
;* Programmer: Tony Papadimitriou
;* Purpose   : LCD-related OS-called routines
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

fLCDInit            equ       *-OSCommands/2      ;Initialize the LCD display
                    dw        ?LCD.Init

fLCDCls             equ       *-OSCommands/2      ;Clear the LCD display
                    dw        ?LCD.Cls

fLCDOn              equ       *-OSCommands/2      ;Enable the LCD display
                    dw        ?DispOn

fDirLeft            equ       *-OSCommands/2      ;Set write direction towards left (eg. numbers)
                    dw        ?DirLeft

fDirRght            equ       *-OSCommands/2      ;Set write direction towards right (normal)
                    dw        ?DirRght

fSetAddr            equ       *-OSCommands/2      ;Set LCD address
                    dw        ?SetDDRAM

fClrEOL             equ       *-OSCommands/2      ;Clear to the end of current LCD line
                    dw        ?ClrEOL

fLCDPutChar         equ       *-OSCommands/2      ;Put a character to the LCD display
                    dw        ?LCD.PutChar

#PAGE ;Operating System routines expanded
**********************************************************************
*                 Operating System routines expanded                 *
**********************************************************************
                    #ROM

#PAGE ;GENERAL-PURPOSE ROUTINES
*********************************************************************
*                     GENERAL-PURPOSE ROUTINES                      *
*********************************************************************

?Delay50            pshx
                    ldx       #50
                    os        fDelayMS
                    pulx
                    rts
#PAGE
                    #RAM
?LCD.Addr           rmb       1
?LCD.Dir            rmb       1

                    #ROM
*********************************************************************
*                         LCD EQUATES                               *
*********************************************************************
?LCD_E              equ       Bit1.               ;for modified EVBU
?LCD_RW             equ       Bit2.               ;for modified EVBU
?LCD_RS             equ       Bit0.               ;for modified EVBU
?LCD_BUSY           equ       Bit7.               ;for modified EVBU

?LCD_CTRL           equ       PORTB               ;for modified EVBU
?LCD_Data           equ       PORTC               ;for modified EVBU
?LCD_DDR            equ       DDRC                ;for modified EVBU

*********************************************************************
*                        LCD COMMANDS                               *
*********************************************************************
?cCLS               equ       %00000001           ;Clear LCD display
?cHOME              equ       %00000010           ;Home the cursor
?cDECNSHF           equ       %00000100           ;Decrement cursor, no display shift
?cDECSHF            equ       %00000101           ;Decrement cursor, display shift
?cINCNSHF           equ       %00000110           ;Increment cursor, no display shift
?cINCSHF            equ       %00000111           ;Increment cursor, display shift
?cND                equ       %00001000           ;Display OFF
?cDNCNB             equ       %00001100           ;Display ON, no cursor, no blink
?cDNCB              equ       %00001101           ;Display ON, no cursor, blink
?cDCNB              equ       %00001110           ;Display ON, cursor on, no blink
?cDCB               equ       %00001111           ;Display ON, cursor on, blink
?cSHIFTL            equ       %00011000           ;Display Shift Left
?cSHIFTR            equ       %00011100           ;Display Shift Right
?cMOVEL             equ       %00010000           ;Cursor Move Left
?cMOVER             equ       %00010100           ;Cursor Move Right

*********************************************************************
*                     LCD-RELATED ROUTINES                          *
*********************************************************************

*****
* CLS - Clear the LCD display
*****
?LCD.Cls            lda       #?cCLS
                    bra       ?WCommLCD

*****
* Home - Home the cursor
*****
?LCD.Home           lda       #?cHOME
                    bra       ?WCommLCD

*****
* Input: RegA holds ASCII character to display
* NOTES: Character is displayed and cursor advanced
*****
?LCD.PutChar        lda       A_,y
                    jsr       ?ASCIILCD           ;convert standard ASCII to LCD codes
                    bra       ?WDataLCD           ;write it out

*****
* INPUT : Nothing
* OUTPUT: Nothing
* NOTES : LCD is initialized
*****
?LCD.Init           lda       #$FF                ;set LCD port for writing
                    sta       ?LCD_DDR
                    bsr       ?Delay50            ;wait for 50ms (45ms only required)
                    lda       #%00111000          ;set 8-bit data, 1/16 duty, 5x7 dots
                    bsr       ?CommandModeLCD
                    bsr       ?WriteLCD
                    bsr       ?Delay50            ;wait for 50ms (4.1ms only required)
;do it once again in case it was originally set at 4-bit bus
                    bsr       ?WriteLCD
                    bsr       ?Delay50            ;wait for 50ms (not needed, just do)
                    bsr       ?WriteLCD
                    jsr       ?WaitBusy
                    bsr       ?WCommLCD
                    bsr       ?LCD.Cls
                    bsr       ?DispOn
                    jsr       ?DirRght
                    bra       ?LoadGR             ;Load the Greek Character set

*****
* Turn the LCD display on, no cursor
*****
?DispOn             lda       #?cDNCNB
          ; falls through to ?WCommLCD

*****
* Write the LCD command (NO REGISTERS ARE DESTROYED) A holds instruction
*****
?WCommLCD           jsr       ?WaitBusy
                    bsr       ?CommandModeLCD
                    bsr       ?WriteLCD
                    jmp       ?WaitBusy           ;get cursor address

*****
* Write LCD Data and toggle Write enable on/off
*****
?WriteLCD           pshx
                    ldx       #REGS
                    bset      [?LCD_CTRL,x,?LCD_E ;enable Write operation
                    sta       ?LCD_Data           ;put command data on bus
                    bclr      [?LCD_CTRL,x,?LCD_E ;disable Write operation
                    pulx
                    rts

*****
* Write the LCD data (NO REGISTERS ARE DESTROYED) A holds data
*****
?WDataLCD           jsr       ?WaitBusy
                    bsr       ?DataModeLCD
                    bsr       ?WriteLCD
                    jmp       ?WaitBusy           ;get cursor address

?DataModeLCD        pshx
                    ldx       #REGS
                    bset      [?LCD_CTRL,x,?LCD_RS ;--- select data
                    bclr      [?LCD_CTRL,x,?LCD_RW ;--- write mode
                    pulx
                    rts

?CommandModeLCD     pshx
                    ldx       #REGS
                    bclr      [?LCD_CTRL,x,?LCD_RS+?LCD_RW ;select command write mode
                    pulx
                    rts

*****
* SetCGRAM - Set CG RAM address (A holds address 0-255)
*****
?SetCGRAM           anda      #%00111111          ;mask off non-address bits
                    ora       #%01000000          ;mix with SET CGRAM command
                    bra       ?WCommLCD

*****
* FixAddr - Fix LCD DDRAM address format to SetDDRAM address format
*           A holds LCD format address on input, SetDDRAM format on output
*****
?FixAddr            cmpa      #$40                ;is it line 2?
                    blo       ?FixAddr.Line1      ;address is in correct format
                    suba      #$40                ;convert to column without line info
                    ora       #$80                ;add line 2 info
?FixAddr.Line1      rts

*****
* LoadGR - Load the Greek character set into unused LCD characters
*****
?LoadGR             clra                          ;beginning address to write
                    bsr       ?SetCGRAM
                    ldx       #?GreekTab          ;start at beginning of data table
?LoadGR1            lda       ,x
                    jsr       ?WaitBusy
                    bsr       ?DataModeLCD
                    anda      #%00011111          ;mask off unused bits just in case
                    bsr       ?WriteLCD
                    inx                           ;point to next sequence or code
                    cpx       #?GreekTabEnd       ;have we loaded all characters?
                    blo       ?LoadGR1
                    clra                          ;get away from CG RAM and into DD RAM
                    bra       ?SetDDRAM.Local
?GreekTab           equ       *                   ;Table of Greek 5x7(8) dot characters
* PI
                    fcb       %11111              ;*****
                    fcb       %01010              ; * *
                    fcb       %01010              ; * *
                    fcb       %01010              ; * *
                    fcb       %01010              ; * *
                    fcb       %01010              ; * *
                    fcb       %01010              ; * *
                    fcb       %00000              ;-----
* OMEGA
                    fcb       %01110              ; ***
                    fcb       %10001              ;*   *
                    fcb       %10001              ;*   *
                    fcb       %10001              ;*   *
                    fcb       %01010              ; * *
                    fcb       %01010              ; * *
                    fcb       %11011              ;** **
                    fcb       %00000              ;-----
* KSI
                    fcb       %11111              ;*****
                    fcb       %00000              ;
                    fcb       %00000              ;
                    fcb       %01110              ; ***
                    fcb       %00000              ;
                    fcb       %00000              ;
                    fcb       %11111              ;*****
                    fcb       %00000              ;-----
* GAMMA
                    fcb       %11111              ;*****
                    fcb       %10000              ;*
                    fcb       %10000              ;*
                    fcb       %10000              ;*
                    fcb       %10000              ;*
                    fcb       %10000              ;*
                    fcb       %10000              ;*
                    fcb       %00000              ;-----
* DELTA
                    fcb       %00100              ;  *
                    fcb       %01010              ; * *
                    fcb       %10001              ;*   *
                    fcb       %10001              ;*   *
                    fcb       %10001              ;*   *
                    fcb       %10001              ;*   *
                    fcb       %11111              ;*****
                    fcb       %00000              ;-----
* LAMDA
                    fcb       %00100              ;  *
                    fcb       %01010              ; * *
                    fcb       %10001              ;*   *
                    fcb       %10001              ;*   *
                    fcb       %10001              ;*   *
                    fcb       %10001              ;*   *
                    fcb       %10001              ;*   *
                    fcb       %00000              ;-----
* PHI
                    fcb       %00100              ;  *
                    fcb       %01110              ; ***
                    fcb       %10101              ;* * *
                    fcb       %10101              ;* * *
                    fcb       %01110              ; ***
                    fcb       %00100              ;  *
                    fcb       %00100              ;  *
                    fcb       %00000              ;-----
* PSI
                    fcb       %10101              ;* * *
                    fcb       %10101              ;* * *
                    fcb       %10101              ;* * *
                    fcb       %01110              ; ***
                    fcb       %00100              ;  *
                    fcb       %00100              ;  *
                    fcb       %00100              ;  *
                    fcb       %00000              ;-----
?GreekTabEnd        equ       *                   ;End of Table of Greek

*****
* INPUT : Param (or A) holds address as follows:
*         Row (either 1 or 2) is in bit 7 as 0 or 1 respectively
*         Column (0 through 39) is in bits 6-0
* OUTPUT: SetDDRAM instruction is executed for the given address
*****
?SetDDRAM           lda       A_,y
?SetDDRAM.Local     tsta                          ;is address given for row 2?
                    bpl       ?SetDRAM2           ;no, skip row 2 adjustment
?SetDRAM1           adda      #$40                ;yes, adjust column address for row 2
?SetDRAM2           ora       #$80                ;mix address with SET DDRAM command
                    jmp       ?WCommLCD

*****
* Convert standard ASCII to LCD, actually only DOS-Greek codes are affected
*****
?ASCIILCD           cmpa      #' '                ;is it below space
                    bhi       ?ASCII.1
                    lda       #' '                ;yes, convert to space
                    rts                           ;and get out
?ASCII.1            cmpa      #'€'                ;is it below Greek Alpha?
                    blo       ?ASCII.Exit         ;yes, no more checks
                    cmpa      #'—'                ;is it higher than Greek Omega?
                    bhi       ?ASCII.Exit         ;yes, no more checks
                    suba      #'€'                ;Less Greek Alpha for zero-based
                    tab
                    ldx       #?ASCII.Table
                    abx
                    lda       ,x                  ;get corresponding character
?ASCII.Exit         rts
?ASCII.Table        fcb       'AB',3,4,'EZH',$F2,'IK',5,'MN',2,'O',0,'P',$F6,'TY',6,'X',7,1

*****
* fClrEOL - Clear to end of line
*****
?ClrEOL             bsr       ?WaitBusy           ;get the current DDRAM address in LCD.Addr
                    lda       ?LCD.Addr           ;save current DDRAM address in A
                    psha
                    cmpa      #$40                ;is it line 1 or 2?
                    blo       ?ClrEOL.Line1       ;skip subtraction
                    suba      #$40                ;get column number regardless of line
?ClrEOL.Line1       nega                          ;column = -column
                    adda      #40                 ;A = line length - column
                    tab                           ;Move counter to B
                    lda       #' '                ;get a space character in A
?ClrEOL.Loop        jsr       ?WDataLCD
                    decb
                    bne       ?ClrEOL.Loop
                    pula
                    jsr       ?FixAddr            ;convert to proper format for SetDDRAM
                    bra       ?SetDDRAM.Local

*****
* DirLeft - Set write direction towards left (eg. numbers)
* DirRght - Set write direction towards right (normal)
*****
?DirLeft            lda       #?cDECNSHF
                    bra       ?SetDirection

?DirRght            lda       #?cINCNSHF

?SetDirection       sta       ?LCD.Dir
                    jmp       ?WCommLCD

*****
* Wait while LCD is busy. On exit LCD.Addr holds address read from LCD
*****
?WaitBusy           psha
                    pshx
                    ldx       #REGS
                    clr       [?LCD_DDR,x         ;change Data register to inputs
                    bclr      [?LCD_CTRL,x,?LCD_RS ;configure check busy flag/address mode
                    bset      [?LCD_CTRL,x,?LCD_RW+?LCD_E ;enable Read operation
                    brset     [?LCD_Data,x,?LCD_BUSY,* ;wait for busy flag to reset
                    lda       ?LCD_Data           ;get the Address
                    bclr      [?LCD_CTRL,x,?LCD_E+?LCD_RW ;disable Read operation and change to instruction mode
                    anda      #$7F                ;mask off busy flag
                    sta       ?LCD.Addr           ;save address read
                    com       [?LCD_DDR,x         ;set Data register to outputs
                    pulx
                    pula
                    clc
                    rts

****
* Clear the top LCD line
****
?ClearLine.1        psha
                    clra                          ;point to line 1
                    jsr       ?SetDDRAM.Local
                    os        fClrEOL
                    pula
                    rts

****
* Clear the bottom LCD line
****
?ClearLine.2        psha
                    lda       #$40                ;point to line 2
                    jsr       ?SetDDRAM.Local
                    os        fClrEOL
                    pula
                    rts

          ; Print message pointed by X on LCD line 2
LCDPrintLine2       psha
                    lda       #$40                ;point to line 2
                    jsr       ?SetDDRAM.Local
                    bra       ?PrintIt.Loop
          ; Print message pointed by X on LCD line 1
LCDPrintLine1       clra                          ;point to line 1
                    jsr       ?SetDDRAM.Local
          ; Print message pointed by X on current line and cursor position
LCDPrint            psha
?PrintIt.Loop       lda       ,x
                    beq       ?PrintIt.Exit
                    os        fLCDPutChar
                    inx
                    bra       ?PrintIt.Loop
?PrintIt.Exit       pula
                    os        fClrEOL             ;and clear to the end of line
                    rts

#ifmain
                    #include  DISPATCH.MOD
#endif

                    #ROM