               org       $f800
Start          lds       #$ff
               bsr       ?Delay

               bra       other

?Delay         ldx       #10
               dex
               bne       *-1
               rts

Other

               #include  local.inc

               org       $fffe
               dw        Start
