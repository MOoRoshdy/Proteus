;**********************************************************************
;*                        OS Error Codes                              *
;*            (Any number from 0 to 255 may be defined)               *
;**********************************************************************
errNone             equ       0                   ;No Error (normally not used)
errOther            equ       1                   ;Other error
errUnused           equ       2                   ;Unused OS opcode
errBadParm          equ       3                   ;Bad parameter
errFailure          equ       4                   ;Operation failed
errOutOfRange       equ       5                   ;Value out of range
errNotFound         equ       6                   ;Not Found (Search, etc.)