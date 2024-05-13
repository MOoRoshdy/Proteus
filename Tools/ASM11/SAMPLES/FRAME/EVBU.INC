; File     : EVBU.INC
; Purpose  : INCLUDE file for EVBU boards (M68HC11E9 with BUFFALO)
; Author   : Tony Papadimitriou
; Assembler: ASM11 v1.77+

                    #message  旼컴컴컴컴컴컴컴컴컴컴커
                    #message  � Target: EVBU/Buffalo �
                    #message  읕컴컴컴컴컴컴컴컴컴컴켸

#ifndef EVBU
EVBU ;Simply tells us this INCLUDE has been used (use with #ifdef EVBU)
#endif

REGS                EQU       $1000               ;Register Base Address

RAM                 EQU       0                   ;beginning of available RAM
RAM_END             EQU       $47                 ;end of available RAM
STACKTOP            EQU       RAM_END             ;Top of Stack

ROM                 EQU       $100                ;RAM used for program storage
ROM_END             EQU       $1FF                ;end of program storage RAM

EEPROM              EQU       $B600               ;beginning of user EEPROM
EEPROM_END          EQU       $B7FF               ;end of user EEPROM

VECTORS             EQU       $C4                 ;beginning of user JMP vectors
VECTORS_END         EQU       $FF                 ;end of user JMP vectors

?JMPOPCODE          EQU       $7E                 ;JMP opcode

; The following MEMORY directives help you contain your code within the
; available RAM space when using EVBU.

                    #MEMORY   ROM ROM_END
                    #MEMORY   EEPROM EEPROM_END
                    #MEMORY   VECTORS VECTORS_END

                    ; REGISTER BLOCK ABSOLUTES

PORTA               equ       REGS+$00            ;Port A Data
PIOC                equ       REGS+$02            ;Parallel IO Control
PORTC               equ       REGS+$03            ;Port C Data
PORTB               equ       REGS+$04            ;Port B Data
PORTCL              equ       REGS+$05            ;Port C Latched Data
DDRC                equ       REGS+$07            ;Data Direction Register C
PORTD               equ       REGS+$08            ;Port D Data
DDRD                equ       REGS+$09            ;Data Direction Register D
PORTE               equ       REGS+$0A            ;Port E Data
CFORC               equ       REGS+$0B            ;Timer Compare Force
OC1M                equ       REGS+$0C            ;Output Compare 1 Mask
OC1D                equ       REGS+$0D            ;Output Compare 1 Data
TCNT                equ       REGS+$0E            ;Timer Count
TIC1                equ       REGS+$10            ;Timer Input Capture 1
TIC2                equ       REGS+$12            ;Timer Input Capture 2
TIC3                equ       REGS+$14            ;Timer Input Capture 3
TOC1                equ       REGS+$16            ;Timer Output Compare 1
TOC2                equ       REGS+$18            ;Timer Output Compare 2
TOC3                equ       REGS+$1A            ;Timer Output Compare 3
TOC4                equ       REGS+$1C            ;Timer Output Compare 4
TIC4                equ       REGS+$1E            ;Timer Input Capture 4
TOC5                equ       REGS+$1E            ;Timer Output Compare 5
TCTL1               equ       REGS+$20            ;Timer Control 1
TCTL2               equ       REGS+$21            ;Timer Control 2
TMSK1               equ       REGS+$22            ;Timer Interrupt Mask 1
TFLG1               equ       REGS+$23            ;Timer Interrupt Flag 1
TMSK2               equ       REGS+$24            ;Timer Interrupt Mask 2
TFLG2               equ       REGS+$25            ;Timer Interrupt Flag 2
PACTL               equ       REGS+$26            ;Pulse Accumulator Control
PACNT               equ       REGS+$27            ;Pulse Accumulator Counter
SPCR                equ       REGS+$28            ;SPI Control Register
SPSR                equ       REGS+$29            ;SPI Status Register
SPDR                equ       REGS+$2A            ;SPI Data Register
BAUD                equ       REGS+$2B            ;Baud Rate Control Register
SCCR1               equ       REGS+$2C            ;SCI Control 1
SCCR2               equ       REGS+$2D            ;SCI Control 2
SCSR                equ       REGS+$2E            ;SCI Status Register
SCDR                equ       REGS+$2F            ;SCI Data Register
ADCTL               equ       REGS+$30            ;AD Control Status Register
ADR1                equ       REGS+$31            ;AD Result 1
ADR2                equ       REGS+$32            ;AD Result 2
ADR3                equ       REGS+$33            ;AD Result 3
ADR4                equ       REGS+$34            ;AD Result 4
BPROT               equ       REGS+$35            ;Block Protect
EPROG               equ       REGS+$36            ;EPROG (E20 only, not E9)
OPTION              equ       REGS+$39            ;System Configuration Options
COPRST              equ       REGS+$3A            ;COP Reset
PPROG               equ       REGS+$3B            ;EEPROM Programming Control
HPRIO               equ       REGS+$3C            ;Highest Interrupt Priority
INIT                equ       REGS+$3D            ;INIT
CONFIG              equ       REGS+$3F            ;Configuration Register

?B                  equ       $FF7C               ;Base for user routines below
          ; BUFFALO USER CALLABLE SUBROUTINES (eg. JSR .BPCLR)
.WARMST             equ       ?B+00               ;warm start
.BPCLR              equ       ?B+03               ;clear breakpoint table
.RPRINT             equ       ?B+06               ;display user registers
.HEXBIN             equ       ?B+09               ;convert ascii hex char to binary
.BUFFAR             equ       ?B+12               ;build hex argument from buffer
.TERMAR             equ       ?B+15               ;read hex argument from terminal
.CHGBYT             equ       ?B+18               ;modify memory at address in x
.READBU             equ       ?B+21               ;read character from buffer
.INCBUF             equ       ?B+24               ;increment buffer pointer
.DECBUF             equ       ?B+27               ;decrement buffer pointer
.WSKIP              equ       ?B+30               ;find non-whitespace char in buffer
.CHKABR             equ       ?B+33               ;check for abort from terminal
.UPCASE             equ       ?B+36               ;convert to upper case
.WCHEK              equ       ?B+39               ;check for white space
.DCHEK              equ       ?B+42               ;check for delimeter
.INIT               equ       ?B+45               ;initialize i/o device
.INPUT              equ       ?B+48               ;low level input routine
.OUTPUT             equ       ?B+51               ;low level output routine
.OUTLHL             equ       ?B+54               ;display top 4 bits as hex digit
.OUTRHL             equ       ?B+57               ;display bottom 4 bits as hex digit
.OUTA               equ       ?B+60               ;output ascii character in A
.OUT1BY             equ       ?B+63               ;display the hex value of byte at X
.OUT1BS             equ       ?B+66               ;out1byt followed by space
.OUT2BS             equ       ?B+69               ;display 2 hex bytes at x and a space
.OUTCRL             equ       ?B+72               ;carriage return, line feed to terminal
.OUTSTR             equ       ?B+75               ;display string at X (term with $04)
.OUTST0             equ       ?B+78               ;outstrg with no initial carr ret
.INCHAR             equ       ?B+81               ;wait for and input a char from term
.VECINT             equ       ?B+84               ;initialize RAM vector table

                    #VECTORS
                    org       VECTORS

; The following section puts the JMP opcodes in the pseudo-vector area
; so the user need only use DW LABEL instructions to fill the rest
; DWs must be spaced one byte apart from one another to skip over the JMPs
; You could delete this and use whole JMP LABEL instructions starting at
; #VECTORS with the above ORG in place.

                    FCB       ?JMPOPCODE          ;SCI
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;SPI
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Pulse Accumulator Input
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Pulse Accumulator Overflow
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Timer Overflow
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;TIC4 / TOC5
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Timer Output Compare 4
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Timer Output Compare 3
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Timer Output Compare 2
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Timer Output Compare 1
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Timer Input Capture 3
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Timer Input Capture 2
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Timer Input Capture 1
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Timer interrupt
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;IRQ
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;XIRQ
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;SoftWare Interrupt
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Illegal Opcode Trap
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;COP Failure (RESET)
                    ORG       *+2
                    FCB       ?JMPOPCODE          ;Clock Monitor Failure (RESET)

                    org       VECTORS+1           ;ready to accept first DW statement

                    #DATA
                    org       EEPROM              ;points to actual EEPROM
                    #RAM
                    org       RAM                 ;points to beginning of user RAM
                    #ROM
                    org       ROM                 ;points to RAM used for program storage

                    ; END OF FILE