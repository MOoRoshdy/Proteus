;***********************************************
;* Program   :
;* Programmer: Tony Papadimitriou
;* Purpose   :
;* Language  : MC68HC11 (ASM11 v1.84+)
;* Status    : The status of this program skeleton is FREEWARE
;* History   : 99.xx.xx Version 1.00    Original
;***********************************************

                    #EXTRAON                      ; Allow extra mnemonics
                    #OPTRELON                     ; Show optimization warnings for JMP/JSR
                    #OPTRTSOFF                    ; Do not show optimization warnings for JSR/BSR, RTS
                    #SPACESOFF                    ; Do not allow spaces within expressions (v1.48 or later)

#ifdef ?
  #message ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  #message ³ Available conditionals (for use with -Dx option)
  #message ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  #message ³ DEBUG: for SIM11x runs (faster bps, etc.)
  #message ³ E2: Target is 811E2 MCU
  #message ³ E9: Target is 711E9 MCU
  #message ³ F1: Target is 11F1 MCU (single-chip mode)
  #message ³ ASPISYS: When F1 is also defined, target is the
  #message ³ ÿÿÿÿÿÿÿÿÿASPiSYS F1 Board (32K+32K expanded mode)
  #message ³ MAP: OS11 Modules with source-level MAP info
  #message ³ NOINTS: Polled mode SCI routines
  #message ³ FORCEILLOP: Force the ILLOP test (DEBUG)
  #message ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  #fatal Run ASM11 -Dx (where x is any of the above)
#endif

                    #listoff                      ; Turn off listing of equates
#ifdef E9
                    #include  711E9.INC           ; MC68HC711E9 equates
#else
#ifdef E2
                    #include  811E2.INC           ; MC68HC811E2 equates
#else
#ifdef F1
  #ifdef ASPISYS
                    #include  EXP-F1.INC          ; ASPiSYS expanded F1 board
  #else
                    #include  11F1.INC            ; Single-Chip 11F1
  #endif
#else
                    #fatal    You haven't defined MCU type (-D? for help)
#endif
#endif
#endif
                    #include  COMMON.INC          ; MCU-independent equates
                    #liston                       ; Turn listing back on for main program

#ifdef DEBUG
                    #message  DEBUG Mode Assembly (do NOT burn device)
#endif

                    #push                         ;save switches
                    #mapoff                       ;Default is no MAP
#ifdef MAP
                    #message  Source-level MAP for OS11 modules
                    #mapon                        ;turn source-level info ON
#endif
                    #SEG9
                    ORG       $FF00               ;beginning of OS call entries table

                    #listoff
                    #include  OS11/OSERRORS.INC   ; OS module error definitions
; --- add here (or enable) whatever modules are needed by your application ---

;                   #INCLUDE  OS11/COMMAND.MOD    ;Command processor
;                   #INCLUDE  OS11/CRC.MOD        ;CRC calculation
;                   #INCLUDE  OS11/EEPROM.MOD     ;EEPROM OS calls
;                   #INCLUDE  OS11/LCD.MOD        ;LCD OS calls
;                   #INCLUDE  OS11/MTOS.MOD       ;Multi-tasking kernel and OS calls
;                   #INCLUDE  OS11/QUEUE.MOD      ;Queue OS calls
;                   #INCLUDE  OS11/S19.MOD        ;S19 loader (OS call)
#ifdef NOINTS ;polled-mode version of SCI routines
                    #INCLUDE  OS11/SCI.MOD        ;Polled SCI-related OS calls
#else         ;interrupt-driven version of SCI routines
                    #INCLUDE  OS11/SCI_INT.MOD    ;Interrupt SCI-related OS calls
#endif
;                   #INCLUDE  OS11/STACK.MOD      ;Stack OS calls
;                   #INCLUDE  OS11/STRINGS.MOD    ;String operations
                    #INCLUDE  OS11/MISC.MOD       ;Miscellaneous OS calls
; The following module must be included last to correctly account for all others
                    #INCLUDE  OS11/DISPATCH.MOD   ;OS call dispatcher

                    #pull                         ;restore switches

#PAGE
;*********************************************************************
;*                        LOCAL EQUATES                              *
;*********************************************************************
SECOND_DELAY        equ       122                 ;~1 sec delay at 8.2ms RTI

#PAGE
;*********************************************************************
;*                 USER RAM AND STACK ORGANIZATION                   *
;*********************************************************************
                    #RAM
#ifdef DEBUG ; Used by sample code
timer               rmb       1                   ;sample used by RTI
#endif

;
; ------------- add your global variables here ----------------------
;

#PAGE
;*********************************************************************
;*                           PROGRAM CODE                            *
;*********************************************************************
                    #ROM

; The following is a standard block of information to be found in every program
Prog.Name           db        'xxxxxxxx'          ;Program Name
Prog.Author         db        'xxxxxxxxxxxxxxxxx' ;Programmer's Name
Prog.Company        db        'xxxxxxxxxxxxx'     ;Company name
Prog.Version        db        1,0                 ;Major, minor version numbers
Prog.Date           db        $99,$01,$01         ;Date in YY,MM,DD in BCD format

                    #push
                    #mapoff -- Turn mapping off
InitUserVars        equ       *
          ; first, clear all RAM except for stacked data
                    pshx
                    tsx
?ClearRAM.Loop      dex
                    clr       ,x
                    cmpx      #0
                    bne       ?ClearRAM.Loop
                    pulx

          ; next, set specific non-zero values
;
; ---------------- add your code here --------------------------------
;
                    rts

;*****
;* InitMCU - Initialize the MCU
;*****
InitMCU             equ       *
          ; --- NOTE: The following STAs must occur within next 53 cycles (64 cycle-limit)

          ;Setup INIT (even the default reset value is required if using a PRU)
                    lda       #REGS>12            ;Changing REGS will affect this line!
          ;$103D must be hardcoded or it won't work, do NOT use INIT because it may not be $103D
                    sta       $103D               ;RAM and I/O Mapping

                    lda       #IRQE.              ;IRQ edge triggered (use your own value here)
                    sta       OPTION              ;System Configuration Options

          ;setup timer prescaler (for TOF, etc.)
                    lda       #%11                ;(use your own value here)
                    sta       TMSK2               ;Timer Interrupt Mask 2

; --- NOTE: The following STAs will affect write-once register bits (even outside 64-cycle limit)
                    ldx       #REGS               ;X points to register base
                    bset      [HPRIO,x,Bit4.      ;Turn off E-clock output (for single chip mode)
; ---
#ifdef ASPISYS+F1
                    jsr       SetChipSelects      ;Set the Chip Selects for expanded mode F1
#endif

#ifdef DEBUG
                    clrd                          ;SIM11x doesn't like uninitialized regs
                    clry
#endif
                    bsr       InitPortDirs
                    bsr       InitRTI
                    bsr       InitSCI
                    bsr       InitSPI
                    bsr       InitAD
                    rts

*********************************************************************

; --- Initialize Port Directions and status (where applicable)
InitPortDirs        clr       PORTA               ;zero all port data
#ifndef F1
                    clr       PORTB
                    clr       PORTC
#endif
                    clr       PORTD
                    clr       PORTE
          ; now, set port pin directions
                    lda       PACTL
                    ora       #%00000000          ;use appropriate value
       ; only these two bits    ^___^___ may be set for PA7 and PA3
                    sta       PACTL
#ifndef F1
                    lda       #%00000000          ;(use your own value here)
                    sta       DDRC
#endif
                    lda       #%00000000          ;(use your own value here)
                    sta       DDRD
                    rts

; --- Initialize the Real-Time Interrupt (8.2ms RTI @ 2MHz MCU E-Clock)
InitRTI             lda       PACTL
                    anda      #%11111100          ;mask off RTR0:1 bits
                    ora       #%01                ;(use your own RTR0:1 bits)
                    sta       PACTL
                    bset      [TMSK2,x,RTIF.      ;Enable RTI subsystem (set RTTI bit)
                    rts

; --- Initialize the Serial Communications Interface for 9600bps, 8-N-1
InitSCI             lda       #BPS_RATE
                    os        fSetBAUD
                    rts

; --- Initialize the Synchronous Peripheral Interface
InitSPI             bset      [DDRD,x,%00111000   ;SPI will be a Master
                    lda       #%01010000          ;Turn SPI on for polled mode
                    sta       [SPCR,x
                    rts

; --- Initialize the Analog-to-Digital Converter
InitAD              lda       #$00                ;(use your own value here)
                    sta       ADCTL
                    rts

                    #pull

;************************************************************
;*              CODE EXECUTION STARTS HERE                  *
;************************************************************
Start               lds       #STACKTOP           ;Initialize the Stack Pointer
                    bsr       InitMCU             ;Initialize the MCU
                    bsr       InitUserVars        ;Initialize User variables

                    cli                           ;Enable interrups

Main                equ       *

;
; ---------------- add more instructions here ------------------------
;

#ifdef DEBUG ; Sample code follows for demonstrating how to make OS calls
BUFSIZE             EQU       11

                    os        fPrint
                    fcs       CR,LF,'Program begins...',CR,LF

                    getx      #BUFSIZE            ;allocate temporary buffer at X

                    lda       #BUFSIZE-1          ;get buffer length
                    sta       ,x                  ;and put it in buffer[0]
                    lda       #$FF                ;starting A/D value to convert
ADLoop              inx                           ;X->buffer[1]
                    os        fConvertAD
                    dex                           ;X->buffer[0]
                    os        fWriteln
                    deca
                    bne       ADLoop

                    givex     #BUFSIZE            ;de-allocate temporary buffer from X

          ; Sample main loop
                    lda       #SECOND_DELAY       ;set up a ~1 second delay
                    sta       timer
MainLoop            wait                          ;Enable ints and wait for one
                    os        fPrint              ;Display a dot after each interrupt
                    fcs       '.'
                    bsr       ServiceRequests     ;Service each request in detail
                    bra       MainLoop

ServiceRequests     tst       timer               ;is timer expired?
                    bne       ServiceRequests.Out ;no, get out of here
                    os        fPrint              ;Display a message when timer expires
                    fcs       CR,LF,'[Timer Reset]',CR,LF
                    lda       #SECOND_DELAY       ;reset timer
                    sta       timer
#ifdef FORCEILLOP
                    #message  Forces Illegal Opcode test
                    os        255                 ;FORCE ILLEGAL OPCODE TRAP TEST
#endif
ServiceRequests.Out rts
#endif

;
; ---------------- add more instructions here ------------------------
;

#if *-Main > 126    ;decide if we can use a long or short jump (not for forwards)
                    jmp       Main
#else
                    bra       Main
#endif

#PAGE
;*********************************************************************
;*                     INTERRUPT SERVICE ROUTINES                    *
;*********************************************************************

                    #ROM
;**********************************************************************
;* RTI - Real Time Interrupt requests come here                       *
;**********************************************************************
RTI_Handler         equ       *
;
; ---------------- add your code here --------------------------------
;
#ifdef DEBUG
; Sample code below decrements timer until it reaches zero
                    tst       timer               ;is timer expired?
                    beq       RTI_Exit            ;yes, get out
                    dec       timer               ;decrement timer
#endif
;
; ---------------- add your code here --------------------------------
;
RTI_Exit            ldx       #REGS
                    bclr      [TFLG2,x,#NOT^$40   ;Reset the RTI int
                    rti

;**********************************************************************
;* IRQ - External Interrupt requests (IRQ and STRA) come here         *
;**********************************************************************
IRQ_Handler
#ifndef F1 ;the following section does not apply to F1 MCUs
                    lda       PIOC                ;Determine if IRQ was from STRA
                    bita      #STAF.              ;Is the STAF set?
                    beq       IRQ_Pin             ;No, go to IRQ pin interrupt
                    lda       PORTCL              ;Read latched data to clear STAF
;
; ---------------- add your code here --------------------------------
;
                    rti
IRQ_Pin             equ       *
#endif
;
; ---------------- add your code here --------------------------------
;
IRQ_Exit            rti

;**********************************************************************
;* SPI - Serial Peripheral Interface requests come here               *
;**********************************************************************
SPI_Handler         ldb       SPSR
                    bpl       SPI_Exit
                    lda       SPDR                ;get received data
;
; ---------------- add your code here --------------------------------
;
SPI_Exit            rti

;**********************************************************************
;* PAI - Pulse Accumulator Input interrupt requests come here         *
;**********************************************************************
PAI_Handler         equ       *
;
; ---------------- add your code here --------------------------------
;
                    lda       #Bit5.              ;Reset the interrupt
                    sta       TFLG2
PAI_Exit            rti

;**********************************************************************
;* PAO - Pulse Accumulator Overflow interrupt requests come here      *
;**********************************************************************
PAO_Handler         equ       *
;
; ---------------- add your code here --------------------------------
;
                    lda       #Bit4.              ;Reset the interrupt
                    sta       TFLG2
PAO_Exit            rti

;**********************************************************************
;* RTO - Real Time Overflow interrupt requests come here              *
;**********************************************************************
RTO_Handler         equ       *
;
; ---------------- add your code here --------------------------------
;
                    lda       #Bit7.              ;Reset the interrupt
                    sta       TFLG2
RTO_Exit            rti

;**********************************************************************
;* TIC4/TOC5 - TIC4 and/or TOC5 interrupt requests come here          *
;**********************************************************************
TIC4_Handler        equ       *
;
; ---------------- add your code here --------------------------------
;
TIC4_Exit           rti

;**********************************************************************
;* TOC3 - TOC3 interrupt requests come here                           *
;**********************************************************************
TOC3_Handler        equ       *
;
; ---------------- add your code here --------------------------------
;
TOC3_Exit           rti

;**********************************************************************
;* TOC2 - TOC2 interrupt requests come here                           *
;**********************************************************************
TOC2_Handler        equ       *
;
; ---------------- add your code here --------------------------------
;
TOC2_Exit           rti

;**********************************************************************
;* TOC1 - TOC1 interrupt requests come here                           *
;**********************************************************************
TOC1_Handler        equ       *
;
; ---------------- add your code here --------------------------------
;
TOC1_Exit           rti

;**********************************************************************
;* TIC3 - TIC3 interrupt requests come here                           *
;**********************************************************************
TIC3_Handler        equ       *
;
; ---------------- add your code here --------------------------------
;
TIC3_Exit           rti

;**********************************************************************
;* TIC2 - TIC2 interrupt requests come here                           *
;**********************************************************************
TIC2_Handler        equ       *
;
; ---------------- add your code here --------------------------------
;
TIC2_Exit           rti

;**********************************************************************
;* TIC1 - TIC1 interrupt requests come here                           *
;**********************************************************************
TIC1_Handler        equ       *
;
; ---------------- add your code here --------------------------------
;
TIC1_Exit           rti

;**********************************************************************
;* XIRQ - External Interrupt requests come here                       *
;**********************************************************************
XIRQ_Handler        equ       *
;
; ---------------- add your code here --------------------------------
;
          ; make sure we don't re-enter this routine (optional)
                    tsx
                    bset      CCR_,x,#X.          ;Disable further XIRQs
XIRQ_Exit           rti

;**********************************************************************
;* ILLOP - Illegal Opcode Interrupt requests come here                *
;* Display a message with the offending PC address in hex and halt    *
;* If stack isn't usable (due to possible corruption) simply halt     *
;* Stack Needed: 22 (9 for caller + 13 for calls without subs)        *
;**********************************************************************
ILLOP_Handler       tsx                           ;First, check stack availability
                    cmpx      #RAM+30             ;Is enough stack space available?
                    blo       ILLOP_Halt          ;No, show simple message only
                    cmpx      #STACKTOP-9         ;Is it above possible stack top (after call)?
                    bhs       ILLOP_Halt          ;Yes, show simple message only
                    bsr       ILLOP_SetSCI        ;Reset the SCI to 9600bps 8-N-1
                    bcs       ILLOP_Exit          ;SCI setup failed, don't show message
                    tsy                           ;get pointer to stack frame in Y
#ifndef NOINTS ;in the interrupt-driven version
                    cli                           ;enable interrupts for SCI_INT
#endif
                    os        fPrint              ;print first part of message
                    fcs       'Illegal opcode at $'
                    ldx       #'00'               ;create buffer on stack (4 bytes)
                    pshx:2                        ;..initialized to string '0000'
                    tsx                           ;and get its pointer in X
                    lda       #16                 ;conversion base
                    sta       ,x                  ;..set in buffer[1]
                    ldd       PC_,y               ;get offending PC address in RegD
          ; Display the offending address
                    ldy       #4                  ;the length of the buffer in Y
                    os        fBin2BCD            ;do the conversion of PC address to hex
                    lda       #4                  ;and a fifth byte with the length
                    psha
                    dex                           ;point to beginning of string
                    os        fWrite              ;and print hex PC address
                    ins                           ;restore stack (faster than PULA)
                    pulx:2
                    os        fPrint
                    fcs       '. '
ILLOP_Halt          lds       #STACKTOP           ;we can safely reset the stack now
                    bsr       ILLOP_SetSCI        ;Reset the SCI to 9600bps 8-N-1
                    bcs       ILLOP_Exit          ;SCI setup failed, don't show message
                    os        fPrint
                    fcs       'System halted!'
                    ldx       #1000
                    os        fDelayMS
ILLOP_Exit          jmp       Halt_MCU            ;Go wait for processor RESET
ILLOP_SetSCI        ldx       #1000
                    os        fDelayMS
                    lda       #BPS_RATE           ;Next, re-set the SCI
                    os        fSetBAUD            ;..by random code
                    rts

;**********************************************************************
;* COP - Computer Operating Properly RESET requests come here         *
;**********************************************************************
COP_Handler         equ       *
;
; ---------------- add your code here --------------------------------
;
COP_Exit            jmp       Start               ;Cannot return with RTI

;**********************************************************************
;* CMF - Clock Monitor Failure RESET requests come here               *
;**********************************************************************
CMF_Handler         equ       *
;
; ---------------- add your code here --------------------------------
;
CMF_Exit            jmp       Start               ;Cannot return with RTI

; ------------------ VECTOR SETUP --------------------
                    #VECTORS
                    org       *+2                 ;SCI Handler (in SCI_INT.MOD)
                    dw        SPI_Handler         ;SPI
                    dw        PAI_Handler         ;Pulse Accumulator Input
                    dw        PAO_Handler         ;Pulse Accumulator Overflow
                    dw        RTO_Handler         ;Timer Overflow
                    dw        TIC4_Handler        ;TIC4 / TOC5
                    org       *+2                 ;Timer Output Compare 4 (in MTOS.MOD)
                    dw        TOC3_Handler        ;Timer Output Compare 3
                    dw        TOC2_Handler        ;Timer Output Compare 2
                    dw        TOC1_Handler        ;Timer Output Compare 1
                    dw        TIC3_Handler        ;Timer Input Capture 3
                    dw        TIC2_Handler        ;Timer Input Capture 2
                    dw        TIC1_Handler        ;Timer Input Capture 1
                    dw        RTI_Handler         ;Timer interrupt
                    dw        IRQ_Handler         ;IRQ for module select
                    dw        XIRQ_Handler        ;XIRQ
                    org       *+2                 ;SoftWare Interrupt (in DISPATCH.MOD)
                    dw        ILLOP_Handler       ;Illegal Opcode Trap
                    dw        COP_Handler         ;COP Failure (RESET)
                    dw        CMF_Handler         ;Clock Monitor Failure (RESET)
                    dw        Start               ;RESET vector
#ifnz *
                    #error    Incorrect or misplaced vectors
#endif
                    end       Start