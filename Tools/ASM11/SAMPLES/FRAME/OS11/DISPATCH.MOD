;**********************************************************************
;* Module    : DISPATCH.MOD
;* Programmer: Tony Papadimitriou
;* Purpose   : The dispatcher module for OS calls
;* Language  : MC68HC11 (ASM11 v1.83+)
;* Status    : FREEWARE, Copyright (c) 1999 by Tony Papadimitriou
;* Segments  : RAM    : Variables
;*           : ROM    : Code
;*           : SEG9   : OS definitions (this allows adding more functions)
;*           : VECTORS: SWI vector
;* Note(s)   : INCLUDE last (i.e., after ALL OS-defining includes
;*           : This file also contains functions that are used
;*           : practically in every program, such as fDelayMS
;*           : Occupies SWI vector
;* History   : 99.11.01 Original
;**********************************************************************

#ifmain ;------------------------------------------------------------
                    #listoff
                    #include  811E2.INC
                    #include  COMMON.INC
                    #liston

                    #SEG9
                    org       $FF00
                    #ROM
                    org       $F800
#endif ;-------------------------------------------------------------

                    #SEG9
#ifndef OSCommands
OSCommands          equ       *
#endif

fDelayMS            equ       *-OSCommands/2      ;Delay variable number of ms
                    dw        ?DelayMS

fUpcase             equ       *-OSCommands/2      ;Convert char in RegA to uppercase
                    dw        ?Upcase

?OS.Entries         equ       *-OSCommands/2      ;Number of opcodes defined

#if ?OS.Entries > 255
?OS_16BIT
                    #warning  Max. functions (256) exceeded, redesign for OSW
#endif

                    #ROM
;**********************************************************************
;*               OS DISPATCHER (OS CALLS COME HERE)                   *
;**********************************************************************
;* Call format: OS CallName                                           *
;* Returns    : No Carry if no error, B is unaffected                 *
;*            : Carry if error, B holds error code                    *
;* Note(s)    : Interrupts will be allowed during the call if the I   *
;*            : bit before the call was clear, otherwise they won't.  *
;* Total Stack: 11 (9 for caller + 2 for local storage without subs)  *
;**********************************************************************
                    #push
                    #mapoff
?SWI_Handler        tsy                           ;point Y to SWI stack frame
                    brset     CCR_,y,I.,?SWI_Continue ;if I bit was set before OS call, don't allow ints
                    cli                           ;Enable interrupts
?SWI_Continue       ldx       PC_,y               ;adjust PC for opcode
#ifdef ?OS_16BIT
                    ldd       ,x                  ;OSW type calls
                    inx                           ;skip 2nd opcode byte
#else
                    clra                          ;we're gonna use D (for OS calls)
                    ldb       ,x                  ;get OS opcode byte
#endif
                    inx                           ;skip 1st opcode byte
                    stx       PC_,y               ;and save new PC to return to
                    cpd       #?OS.Entries        ;is it a valid OpCode?
                    bhs       ?SWI_Ret
#ifdef ?OS_16BIT
                    lsld                          ;multiply by two (size of table entries)
                    addd      #OSCommands         ;add starting address
                    xgdx                          ;and put result in X
#else
                    ldx       #OSCommands         ;point to command table
                    abx:2                         ;add offset twice (size of table entries)
#endif
                    ldx       ,x                  ;get function JMP vector
                    jsr       ,x                  ;Perform function
                    tsx                           ;X now points to user stack frame
;now, we should prepare the stack frame to be returned with appropriate values
                    bcs       ?SWI_Error
                    bclr      CCR_,x,C.           ;clear Carry flag
                    rti                           ;no error exit
?SWI_Error          bset      CCR_,x,C.           ;set Carry flag
                    stb       B_,x                ;save error code for user
#ifndef AnRTI
AnRTI
#endif
                    rti                           ;A globally accessed RTI

; The following section handles invalid OS Opcodes
?SWI_Ret            ldx       PC_,y               ;adjust PC to start of opcode
                    dex:2                         ;..back 1 byte for operand and 1 for the OS opcode
                    stx       PC_,y               ;and save new PC to return to
                    ldx       ILLOP_VECTOR
                    cpx       #ERASED_STATE       ;Check if not initialized (for EPROM, ie., $FFFF)
                    beq       ?SWI_Ret.2
                    jmp       ,x                  ;Invalid System Call
?SWI_Ret.2          equ       *                   ;In case ILLOP handler not installed
Halt_MCU            ldx       #500
                    os        fDelayMS            ;Let pending hardware events complete
                    sei                           ;Disable interrupts
; --- Shut down all peripherals (on and off chip)
                    pshx
                    ldx       #REGS
                    clr       [OPTION,x           ;Power-down A/D
                    clr       [SCCR2,x            ;Disable SCI
                    clr       [SPCR,x             ;Disable SPI
                    clr       [TMSK1,x            ;Disable IC/OC interrupts
                    clr       [TMSK2,x            ;Disable Timer interrupts
                    pulx
                    os        fDelayMS            ;Let subsystems turn off
                    cls                           ;Enable STOP instruction
#ifdef DEBUG
                    nop                           ;Instead of STOP (for SIM11x)
#else
                    stop                          ;and stay here in deep sleep
#endif
                    bra       *-1                 ;in case of XIRQ, go back to sleep
                    #pull


; Purpose: Delay ~ RegX milliseconds (not counting caller's overhead)
?DelayMS            ldx       X_,y                ;Get milliseconds to delay
?DelayMS.Loop       pshx
#ifdef DEBUG
                    ldx       #1                  ;for SIM11x use minimum delay
#else
                    ldx       #333                ;constant for 1 millisecond
#endif
                    dex
                    bne       *-1
                    pulx
                    dex
                    bne       ?DelayMS.Loop
                    clc                           ;No errors in any case
                    rts

; Purpose: Convert ASCII character in A to uppercase
; Input  : RegA->char
; Output : RegA->CHAR
?Upcase             lda       A_,y
                    bsr       Upcase
                    sta       A_,y
                    clc
                    rts

; Routine: Upcase
; Purpose: Convert character in A to uppercase
; Input  : A=character
; Output : A=CHARACTER
Upcase              cmpa      #'a'                 ;less than 'A'?
                    blo       ?Upcase.Exit         ;yes, skip
                    cmpa      #'z'                 ;greater than 'Z'?
                    bhi       ?Upcase.Exit         ;yes, skip
                    suba      #'a'-'A'             ;do the conversion
?Upcase.Exit        rts

                    #VECTORS
?vectors            equ       *

                    org       $FFF6
                    dw        ?SWI_Handler

                    org       ?vectors

                    end