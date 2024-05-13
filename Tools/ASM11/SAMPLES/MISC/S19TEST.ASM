; Calls the S19LOAD.SUB subroutine for testing it

                    #listoff
                    #include  811E2.INC
                    #liston

Offset              equ       0                   ;Offset to adjust loading location

                    #ROM

Start               lds       #STACKTOP
                    lda       #$0C
                    sta       $102D
                    clrd
                    clrx
                    clry

                    ldx       #Offset
                    bsr       S19

; Now X holds the execution address based on S9 record info
; Jump to code if X non-zero (and no error, Carry set)
                    bcs       Halt                ;Error loading, exit
                    cmpx      #Offset             ;Check if X = offset (or X = 0)
                    beq       Halt                ;If zero difference, don't execute
                    jmp       ,x                  ;Execute loaded program

Halt                cls
                    sei
                    stop
                    bra       *-1

AnRTI               rti

                    #mapoff
                    #include  s19load.sub
                    #mapon

                    #VECTORS
                    dw:20     AnRTI
                    dw        Start

                    end       Start