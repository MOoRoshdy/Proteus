@echo off
rem ---------------------------------------------------------------------
rem Batch file to compile with SBasic and assemble with ASM11 in one step
rem Written by Tony Papadimitriou "<tonyp@acm.org>"
rem ---------------------------------------------------------------------
if "%1" == "" goto Usage
if not exist %1.bas goto NotFound
if "%2" == "8" goto 811E2
SBASIC %1.bas /cd000 /v0000 /s01ff > %1.sba
goto Continue
:811E2
SBASIC %1.bas /cf800 /v0000 /s00ff > %1.sba
:Continue
if errorlevel == 1 goto Error
sb2asm11 %1
del %1.sba
asm11 %1 -rel- -l-
rem del %1.asm
goto Exit
:NotFound
echo ÿ
echo File "%1.bas" was not found.
echo ÿ
goto Exit
:Error
echo ÿ
echo SBasic errors.   Check the produced "%1.sba" for details.
echo ÿ
goto Exit
:Usage
echo ÿ
echo Usage: BAS BasicProg [8]
echo ÿ
echo Compile using SBASIC.EXE compiler, then assemble using ASM11.EXE
echo SB2ASM11.EXE and ASM11.EXE must be in the path somewhere.
echo Use the ASM11 adapted SBasic libraries.
echo ÿ
echo Without the optional 8, the target is 68HC711E9
echo With the 8, the target is 68HC811E2
echo ÿ
:Exit
