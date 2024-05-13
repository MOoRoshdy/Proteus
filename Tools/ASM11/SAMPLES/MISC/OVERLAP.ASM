; Demonstrates the "overlap" warning available in ASM11 v1.65 and later

                    #ROM
                    org       $f800
Start               lds       #$ff
                    clra
                    clrb
                    ldx       #0
                    ldy       #0

                    bsr       subroutine
                    bra       *

                    #DATA
                    org       $f811
                    fcs       "A little string"

                    #ROM
subroutine          nop
                    rts                           ;"overlap" warning here

                    end       Start