;**********************************************************************
;* Module    : CRC.MOD
;* Programmer: Tony Papadimitriou
;* Purpose   : CRC calculation OS-called routine
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

fCRC                equ       *-OSCommands/2      ;Calculate CRC
                    dw        ?CRC

#PAGE ;Operating System routines expanded
**********************************************************************
*                 Operating System routines expanded                 *
**********************************************************************
                    #ROM

; Routine: CRC
; Purpose: Calculate the CRC of a buffer area
; Input  : X -> Pointer to data buffer
;        : Y -> Number of bytes in buffer
;        : A -> Method to use: 1=CRC-16, 2=CCITT
; Output : D -> 16-bit CRC value
; Note(s): Uses 1024 bytes of static table data.
; Stack  : Stack variables used (accessed by nnn,Y) after an TSY
;          Table     Table address              6,Y word
;          Length    Number of bytes to process 4,Y word
;          Address   Pointer to data buffer     2,Y word
;          CRC       Running CRC                0,Y word

?CRC                ldx       Y_,y                ;are there any bytes to process?
                    beq       ?CRC.Exit           ;no, get out

; --- setup table to use ---

                    ldx       #?CRC.Tab1          ;assume method 1
                    cmpa      #1                  ;is it method 1?
                    beq       ?CRC.Cont
                    ldx       #?CRC.Tab2          ;assume method 2
                    cmpa      #2                  ;is it method 2?
                    beq       ?CRC.Cont

?CRC.Error          ldb       #errOutOfRange      ;invalid method specified, exit with error
                    sec
                    rts

; --- create local variables ---

?CRC.Cont           pshx                          ;save table address to use
                    ldx       Y_,y                ;Get caller's Y
                    pshx                          ;Save counter on stack at offset 4
                    ldx       X_,y                ;Get caller's X
                    pshx                          ;Save pointer on stack at offset 2
                    clrx                          ;Start with a zero initial CRC in stack
                    pshx                          ;..put it on stack at offset 0
                    tsy                           ;use Y for stack access

; add byte loop
?CRC.Loop           ldx       2,y                 ;get next byte pointer
                    ldb       ,x                  ;get next byte to be included in CRC
                    inx
                    stx       2,y                 ;save pointer to next byte
                    eorb      1,y
                    ldx       6,y                 ;point to CRC Table
                    abx:2                         ;get index into CRC table (add twice the byte value)
                    lda       0,X                 ;get upper CRC byte
                    ldb       ,y                  ;get old upper CRC byte
                    eorb      1,X                 ;XOR with lower table byte
                    std       ,y                  ;save new CRC
                    ldx       4,y                 ;get counter
                    dex
                    stx       4,y                 ;save decremented counter
                    bne       ?CRC.Loop           ;--> next byte
                    pulx:4                        ;De-allocate local storage (4 words)
?CRC.Exit           tsy                           ;we must reload Y accounting for push
                    sta       A_+4,y              ;..and return address to the SWI handler
                    stb       B_+4,y
                    clc
                    rts

; Table for polynomial = $14003 (CRC-16)
?CRC.Tab1           fdb       $0000,$C0C1,$C181,$0140,$C301,$03C0,$0280,$C241
                    fdb       $C601,$06C0,$0780,$C741,$0500,$C5C1,$C481,$0440
                    fdb       $CC01,$0CC0,$0D80,$CD41,$0F00,$CFC1,$CE81,$0E40
                    fdb       $0A00,$CAC1,$CB81,$0B40,$C901,$09C0,$0880,$C841
                    fdb       $D801,$18C0,$1980,$D941,$1B00,$DBC1,$DA81,$1A40
                    fdb       $1E00,$DEC1,$DF81,$1F40,$DD01,$1DC0,$1C80,$DC41
                    fdb       $1400,$D4C1,$D581,$1540,$D701,$17C0,$1680,$D641
                    fdb       $D201,$12C0,$1380,$D341,$1100,$D1C1,$D081,$1040
                    fdb       $F001,$30C0,$3180,$F141,$3300,$F3C1,$F281,$3240
                    fdb       $3600,$F6C1,$F781,$3740,$F501,$35C0,$3480,$F441
                    fdb       $3C00,$FCC1,$FD81,$3D40,$FF01,$3FC0,$3E80,$FE41
                    fdb       $FA01,$3AC0,$3B80,$FB41,$3900,$F9C1,$F881,$3840
                    fdb       $2800,$E8C1,$E981,$2940,$EB01,$2BC0,$2A80,$EA41
                    fdb       $EE01,$2EC0,$2F80,$EF41,$2D00,$EDC1,$EC81,$2C40
                    fdb       $E401,$24C0,$2580,$E541,$2700,$E7C1,$E681,$2640
                    fdb       $2200,$E2C1,$E381,$2340,$E101,$21C0,$2080,$E041
                    fdb       $A001,$60C0,$6180,$A141,$6300,$A3C1,$A281,$6240
                    fdb       $6600,$A6C1,$A781,$6740,$A501,$65C0,$6480,$A441
                    fdb       $6C00,$ACC1,$AD81,$6D40,$AF01,$6FC0,$6E80,$AE41
                    fdb       $AA01,$6AC0,$6B80,$AB41,$6900,$A9C1,$A881,$6840
                    fdb       $7800,$B8C1,$B981,$7940,$BB01,$7BC0,$7A80,$BA41
                    fdb       $BE01,$7EC0,$7F80,$BF41,$7D00,$BDC1,$BC81,$7C40
                    fdb       $B401,$74C0,$7580,$B541,$7700,$B7C1,$B681,$7640
                    fdb       $7200,$B2C1,$B381,$7340,$B101,$71C0,$7080,$B041
                    fdb       $5000,$90C1,$9181,$5140,$9301,$53C0,$5280,$9241
                    fdb       $9601,$56C0,$5780,$9741,$5500,$95C1,$9481,$5440
                    fdb       $9C01,$5CC0,$5D80,$9D41,$5F00,$9FC1,$9E81,$5E40
                    fdb       $5A00,$9AC1,$9B81,$5B40,$9901,$59C0,$5880,$9841
                    fdb       $8801,$48C0,$4980,$8941,$4B00,$8BC1,$8A81,$4A40
                    fdb       $4E00,$8EC1,$8F81,$4F40,$8D01,$4DC0,$4C80,$8C41
                    fdb       $4400,$84C1,$8581,$4540,$8701,$47C0,$4680,$8641
                    fdb       $8201,$42C0,$4380,$8341,$4100,$81C1,$8081,$4040

; Table for polynomial = $10811 (CCITT)
?CRC.Tab2           fdb       $0000,$1189,$2312,$329B,$4624,$57AD,$6536,$74BF
                    fdb       $8C48,$9DC1,$AF5A,$BED3,$CA6C,$DBE5,$E97E,$F8F7
                    fdb       $1081,$0108,$3393,$221A,$56A5,$472C,$75B7,$643E
                    fdb       $9CC9,$8D40,$BFDB,$AE52,$DAED,$CB64,$F9FF,$E876
                    fdb       $2102,$308B,$0210,$1399,$6726,$76AF,$4434,$55BD
                    fdb       $AD4A,$BCC3,$8E58,$9FD1,$EB6E,$FAE7,$C87C,$D9F5
                    fdb       $3183,$200A,$1291,$0318,$77A7,$662E,$54B5,$453C
                    fdb       $BDCB,$AC42,$9ED9,$8F50,$FBEF,$EA66,$D8FD,$C974
                    fdb       $4204,$538D,$6116,$709F,$0420,$15A9,$2732,$36BB
                    fdb       $CE4C,$DFC5,$ED5E,$FCD7,$8868,$99E1,$AB7A,$BAF3
                    fdb       $5285,$430C,$7197,$601E,$14A1,$0528,$37B3,$263A
                    fdb       $DECD,$CF44,$FDDF,$EC56,$98E9,$8960,$BBFB,$AA72
                    fdb       $6306,$728F,$4014,$519D,$2522,$34AB,$0630,$17B9
                    fdb       $EF4E,$FEC7,$CC5C,$DDD5,$A96A,$B8E3,$8A78,$9BF1
                    fdb       $7387,$620E,$5095,$411C,$35A3,$242A,$16B1,$0738
                    fdb       $FFCF,$EE46,$DCDD,$CD54,$B9EB,$A862,$9AF9,$8B70
                    fdb       $8408,$9581,$A71A,$B693,$C22C,$D3A5,$E13E,$F0B7
                    fdb       $0840,$19C9,$2B52,$3ADB,$4E64,$5FED,$6D76,$7CFF
                    fdb       $9489,$8500,$B79B,$A612,$D2AD,$C324,$F1BF,$E036
                    fdb       $18C1,$0948,$3BD3,$2A5A,$5EE5,$4F6C,$7DF7,$6C7E
                    fdb       $A50A,$B483,$8618,$9791,$E32E,$F2A7,$C03C,$D1B5
                    fdb       $2942,$38CB,$0A50,$1BD9,$6F66,$7EEF,$4C74,$5DFD
                    fdb       $B58B,$A402,$9699,$8710,$F3AF,$E226,$D0BD,$C134
                    fdb       $39C3,$284A,$1AD1,$0B58,$7FE7,$6E6E,$5CF5,$4D7C
                    fdb       $C60C,$D785,$E51E,$F497,$8028,$91A1,$A33A,$B2B3
                    fdb       $4A44,$5BCD,$6956,$78DF,$0C60,$1DE9,$2F72,$3EFB
                    fdb       $D68D,$C704,$F59F,$E416,$90A9,$8120,$B3BB,$A232
                    fdb       $5AC5,$4B4C,$79D7,$685E,$1CE1,$0D68,$3FF3,$2E7A
                    fdb       $E70E,$F687,$C41C,$D595,$A12A,$B0A3,$8238,$93B1
                    fdb       $6B46,$7ACF,$4854,$59DD,$2D62,$3CEB,$0E70,$1FF9
                    fdb       $F78F,$E606,$D49D,$C514,$B1AB,$A022,$92B9,$8330
                    fdb       $7BC7,$6A4E,$58D5,$495C,$3DE3,$2C6A,$1EF1,$0F78

#ifmain
                    #include  DISPATCH.MOD
#endif
                    #ROM