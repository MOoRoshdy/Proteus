****************************************************
* Example for using conditional with user messages *
****************************************************

#ifdef ?
  #message ********************************************
  #message * Available -Dxxx conditional values
  #message ********************************************
  #message * DEBUG: For maximum baud rate (SIM11E)
  #message * ERROR: Causes an error
  #message * MEMORY: Produce a MEMORY Violation warning
  #message ********************************************
  #fatal Run ASM11 -Dx where x is any of the above
#endif

                    #EXTRAON                      ;Allow extra mnemonics

RAM                 EQU       $0000
RAM_END             EQU       $01FF
ROM                 EQU       $D000
ROM_END             EQU       $FFBF
VECTORS             EQU       $FFD6
STACKTOP            EQU       RAM_END

BAUD                EQU       $102B

                    org       *

#ifdef DEBUG
                    #message  DEBUG Mode (do NOT burn device)
SPEED               EQU       $00                 ;115200 bps rate for SIM11E to go faster
#else
SPEED               EQU       $30                 ;9600 bps rate
#endif
                    #ROM
Start               lds       #STACKTOP
                    lda       #SPEED
                    sta       BAUD
          ;--- more code ---

          ;--- the following RMB is only used to force an ERROR
          ;--- for the following IF condition
#ifdef ERROR
                    rmb       $2FB7               ;$2FB7 causes error
#else
                    rmb       $2FB6               ;$2FB6 causes no error
#endif
                    bra       *

          ;You can use the following condition in all your programs to prevent
          ;from writing code that will not fit the device's EPROM
#ifndef MEMORY

  #if * > ROM_END+1
    #ifdef DEBUG
      #warning Program too big; runs into reserved memory
    #else
      #error Program too big; runs into reserved memory
    #endif
  #endif

#else ;MEMORY defined
          ;Instead of the above conditional you could also define a
          ;memory range with $MEMORY and the assembler will warn about
          ;going outside the defined range.  To test it assemble with
          ;the -DMEMORY option.

                    #MEMORY ROM ROM_END
                    #MEMORY VECTORS $FFFF
#endif

                    org       $FFFE
                    dw        Start