; Author   : Tony G. Papadimitriou
; Assembler: ASM11 v1.77+
; Date     : August 25, 1998
; Updated  : July 31, 1999
; Status   : FREEWARE
; Purpose  : Example program on writing code that allows re-filling EPROM with
;            new code.  (This is similar to making multi-session CDs, so each
;            new burning is called a SESSION for the purposes of this demo.)
;            This example shows how things would look during the third session.

                    #listoff
                    #include  711E9.INC           ; Found in ASM11 distribution
                    #liston

; -- I M P O R T A N T --
;
; When filling up your program with new code, the top of memory will be filled
; downwards with vectors (similar to how a stack operates).  Your program
; should only fill memory upwards.  Eventually, it is possible for one to
; overlap the other.  Make sure (by checking the listing or having the -O option
; activated to get appropriate warnings) you have not caused an overlap which,
; of course, would corrupt both code and vectors.

; -- I M P O R T A N T --
;
; Never correct existing code from a previous session.  You should have
; provided hooks for code sections that should be replaceable.  The rest
; you cannot alter.  (Well-tested general-purpose routines could be
; considered safe enough to not be made upgradable, everything else ...).

                    #EXTRAON                      ; Allow extra mnemonics

;*******************************************************************************
;* THE FOLLOWING LINE IS VERY IMPORTANT. START WITH 1 AND ADD 1 FOR EACH NEW   *
;* SESSION YOU CREATE TO KEEP VECTORS CORRECT                                  *
;* (MAKE SURE YOU DON'T LEAVE GAPS IN NUMBERING CONSECUTIVE SESSIONS)          *
;*******************************************************************************
SESSION             equ       3                   ;Add 1 for every new session
*******************************************************************************

#ifz SESSION
                    #error    Oops! SESSION must start with 1
#endif

;The following line defines what an erased EPROM word looks like.  Change
;accordingly if the EPROM you're using has a different erased state (normally,
;it's either $0000 or $FFFF).
ERASED_STATE        equ       $FFFF               ;Erased E(E)PROM word image

                    #RAM
sample              rmb       1

; Define your RAM variables here.  You should not re-arrange the order
; of previous session variable declarations because it will affect the
; code for that session.

; -- Standard reset sequence follows --
                    #ROM
ColdBoot            equ       *
;
; --- Add here only code that *must* be executed within the 64-cycle limit
;     (Normally, you should enable as many things as possible to disable
;     them later in each specific session's reset.  Some things cannot be
;     changed beyond the first burning, such as INIT.  You only have the
;     very first time to decide this, because the routine that searches
;     for your current session will quickly waste the first 64-cycles.)
;
                    ldx       #RVECTORS_END+2     ;+2 is needed for next line's DEX:2
ColdLoop            dex:2                         ;Go back a word
                    ldd       ,x                  ;Get first vector (starting from end)
                    cmpd      #ERASED_STATE       ;Is it uninitialized?
                    bne       ColdLoop
SoftBoot            ldx       2,x                 ;Get vector of last session from previous word
                    lds       #STACKTOP           ;This here frees 64-cycle limit even more.
                    jmp       ,x

Halt                sei                           ;Sample code to halt the MCU
                    cls
                    stop
                    bra       *-1

; --- Original boot sequence
SoftBoot1           equ       *

; --- Session 1 initialization code

                    lda       #1
                    sta       sample
                    bra       Halt

; --- Added new code here
SoftBoot2           equ       *

; --- Session 2 initialization code

                    lda       #2
                    sta       sample
                    bra       Halt

; --- Added new code here
SoftBoot3           equ       *

; --- Session 3 initialization code

                    lda       #3
                    sta       sample
                    bra       Halt

; --- Add new code here
;SoftBoot4 ...
; etc., etc.

;*******************************************************************************
;*                                                                             *
;*                                                                             *
;*    N E V E R   add code above already present code for a previous session   *
;*                                                                             *
;*                                                                             *
;*******************************************************************************

;BootSize           equ       SESSION*2+2         ;\Replaced with the shorter
;                   org       ROM_END+1-BootSize  ;/  ORG below

                    org       -SESSION*2+ROM_END-1 ;DO NOT CHANGE (REQUIRED)
                    dw        ERASED_STATE        ;*** R E Q U I R E D ***

RVECTORS_BEGIN      equ       *

; --- Add here consequent "dw SoftBoot?" statements going backwards
; --- Note that no matter how many entries you add, older ones fall always in
;     the same address
;                   .
;                   .
;                   .

                    dw        SoftBoot3           ;Address of third session (if any)
                    dw        SoftBoot2           ;Address of second session (if any)
RVECTORS_END        dw        SoftBoot1           ;AT LEAST ONE SESSION SHOULD BE DEFINED

#if RVECTORS_END+2-RVECTORS_BEGIN/2 <> SESSION    ;a simple check to avoid silly mistakes
                    #error    Number of SoftBoot entries does not match SESSION
#endif
                    #VECTORS

; --- Define your other vectors here (possibly some pointing to RAM pseudo-
;     vectors, that each session initializes differently).  Specifically,
;     handlers such as that for the SWI could point to RAM so that any
;     important function can be remapped (and possibly fixed or updated).

                    org       $FFFE
                    dw        ColdBoot            ;DO NOT CHANGE THIS LINE

                    end       ColdBoot