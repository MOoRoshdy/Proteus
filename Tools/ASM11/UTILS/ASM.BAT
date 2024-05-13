@echo off
rem Sample Batch file to call ASM11 v1.46+ and act based on errorlevel returned
asm11 %1 %2 %3 %4 %5 %6 %7 %8 %9
if errorlevel == 4 goto usage
if errorlevel == 3 goto warning
if errorlevel == 2 goto error
if errorlevel == 1 goto system
echo Successful assembly.
goto exit
:usage
echo ÿ
echo No programs assembled.
goto exit
:warning
echo Only warnings found, code may be usable.
goto exit
:error
echo Errors found, no code or listing produced.
goto exit
:system
echo System Failure (Disk I/O, etc.)
goto exit
:exit
