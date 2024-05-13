*************************************************************************
*       COMMON EQUATES -- MCU INDEPENDENT -- FOR ASM11 ASSEMBLER        *
*************************************************************************

#ifndef NOT
NOT                 equ       $FF                 ;XOR value to produce NOT result
#endif

                    * Data Type Definition *
Boolean             equ       1
Char                equ       1
ShortInt            equ       1
Byte                equ       1
Word                equ       2
Integer             equ       2
Longint             equ       4

                    * ISR Stack Frame Offset Definition *
PC_                 equ       7
Y_                  equ       5
X_                  equ       3
A_                  equ       2
B_                  equ       1
D_                  equ       1                   ;This is for loading D reversed
CCR_                equ       0

                    * Condition Code Register flags *
S.                  equ       %10000000           ;Stop inhibit
X.                  equ       %01000000           ;XIRQ disable
H.                  equ       %00100000           ;Half Carry
I.                  equ       %00010000           ;IRQ disable
N.                  equ       %00001000           ;Negative
Z.                  equ       %00000100           ;Zero
V.                  equ       %00000010           ;Overflow
C.                  equ       %00000001           ;Carry

                    * General Purpose Bits *
Bit7.               equ       %10000000
Bit6.               equ       %01000000
Bit5.               equ       %00100000
Bit4.               equ       %00010000
Bit3.               equ       %00001000
Bit2.               equ       %00000100
Bit1.               equ       %00000010
Bit0.               equ       %00000001

                    * OPTION Bits *
ADPU.               equ       %10000000           ;A/D Power-Up
CSEL.               equ       %01000000           ;Charge Pump Clock Select
IRQE.               equ       %00100000           ;IRQ Select Edge Sensitive Only
DLY.                equ       %00010000           ;Delay out of STOP mode
CME.                equ       %00001000           ;Clock Monitor Enable
CR1.                equ       %00000010           ;COP Timer Rate Select
CR0.                equ       %00000001           ;COP Timer Rate Select

                    * SCI Bits *
TDRF.               equ       %10000000           ;SCI Transmit Register Empty
TC.                 equ       %01000000           ;SCI Transmit Complete Flag
RDRF.               equ       %00100000           ;SCI Receive Register Full
IDLE.               equ       %00010000           ;SCI Idle Line Detected
OR.                 equ       %00001000           ;SCI Overrun Error
NF.                 equ       %00000100           ;SCI Noise Error
FE.                 equ       %00000010           ;SCI Framing Error

                    * SPI Bits *
SPIE.               equ       %10000000           ;SPI Interrupt Enable
SPE.                equ       %01000000           ;SPI Enable
DWOM.               equ       %00100000           ;PortD OR Wired Mode
MSTR.               equ       %00010000           ;Master Mode Select
CPOL.               equ       %00001000           ;Clock Polarity
CPHA.               equ       %00000100           ;Clock Phase
SRP1.               equ       %00000010           ;SPI Clock Rate Select
SRP0.               equ       %00000001           ;SPI Clock Rate Select

SPIF.               equ       %10000000           ;SPI Transfer Complete Flag
WCOL.               equ       %01000000           ;Write Collision
MODF.               equ       %00010000           ;Mode Fault

                    * SPI Pins *
MISO.               equ       Bit2.               ;Port D pins for manual SPI
MOSI.               equ       Bit3.
SCK.                equ       Bit4.
SS.                 equ       Bit5.

                    * ADCTL (A/D Control/Status) Bits *
CCF.                equ       %10000000           ;Conversions Complete Flag
SCAN.               equ       %00100000           ;Continuous Scan Control
MULT.               equ       %00010000           ;Multiple/Single Channel Control
CD.                 equ       %00001000           ;Channel Select D
CC.                 equ       %00000100           ;Channel Select C
CB.                 equ       %00000010           ;Channel Select B
CA.                 equ       %00000001           ;Channel Select A

                    * PACTL (Pulse Accumulator Control) Bits *
DDRA7.              equ       %10000000           ;Data Directive for PortA[7]
PAEN.               equ       %01000000           ;Pulse Accumulator System Enable
PAMOD.              equ       %00100000           ;Pulse Accumulator Mode
PEDGE.              equ       %00010000           ;Pulse Accumulator Edge Control
DDRA3.              equ       %00001000           ;Data Directive for PortA[3]
I4O5.               equ       %00000100           ;IC4/OC5 select
RTR1.               equ       %00000010           ;RTI Rate Select 1
RTR0.               equ       %00000001           ;RTI Rate Select 0

                    * Timer Bits *
TOF.                equ       %10000000
RTIF.               equ       %01000000
PAOVF.              equ       %00100000
PAIF.               equ       %00010000

                    * PIOC (Parallel IO Control) Bits *
STAF.               equ       %10000000           ;STRA Interrupt Status Flag
STAI.               equ       %01000000           ;STRA Interrupt Enable Mask
CWOM.               equ       %00100000           ;Port C Wired-OR Mode
HNDS.               equ       %00010000           ;Handshake Mode
OIN.                equ       %00001000           ;Output or Input Handshake Select
PLS.                equ       %00000100           ;Pulse/Interlocked Handshake Operation
EGA.                equ       %00000010           ;Active Edge for STRA
INVB.               equ       %00000001           ;Invert STRB

                    * CONTROL ASCII CODES *
NULL                equ        0
NUL                 equ        NULL               ;second spelling for NULL
SOH                 equ        1
STX                 equ        2
ETX                 equ        3
EOT                 equ        4                  ;End of Text/Transmission
ENQ                 equ        5
ACK                 equ        6
BELL                equ        7
BS                  equ        8                  ;Backspace
TAB                 equ        9
LF                  equ       10                  ;Line Feed
VT                  equ       11                  ;Vertical Tab
FF                  equ       12                  ;Form Feed
CR                  equ       13                  ;Carriage Return
SO                  equ       14
SI                  equ       15

DLE                 equ       16
DC1                 equ       17
DC2                 equ       18
DC3                 equ       19
DC4                 equ       20
NAK                 equ       21
SYN                 equ       22
ETB                 equ       23
CAN                 equ       24
EM                  equ       25
SUB                 equ       26
ESC                 equ       27                  ;Escape
FS                  equ       28
GS                  equ       29
RS                  equ       30
US                  equ       31

                    * Miscellaneous *
ERASED_STATE        equ       $FFFF               ;E(E)PROM Erased State

#ifndef BPS_RATE ;if not defined through command line or higher level file
  #ifdef DEBUG
BPS_RATE            equ       125                 ;for SIM11x debugging, use maximum speed
  #else
BPS_RATE            equ       96                  ;9600 bps for the SCI
  #endif
#endif

                    * Various Checks *
#ifdef REGS
  #ifnz REGS&$0FFF
                    #error    REGS not in format $X000 (edit ?11E?.INC)
  #endif
#endif
