               bsr       ?Delay
               bra       Start

?Delay         ldx       #100
               dex
               bne       *-1
               rts
