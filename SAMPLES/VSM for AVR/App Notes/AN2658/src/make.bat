cls

set cpath=C:\Program Files (x86)\Microchip\xc8\v2.10\bin

set CPU=ATtiny807

set include_dirs=-I./OWI_common -I./OWI_polled_uart

del *.cof

set compiler_args=-mcpu=%CPU% -c  -x c -D__%CPU%__ -DF_CPU=10000000 %include_dirs% -mdfp="C:/Program Files (x86)/Microchip/MPLABX/v5.35/packs/Microchip/ATtiny_DFP/2.1.63"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=default -gdwarf-3
set assembler_args=-c  -mcpu=%CPU%  -x assembler-with-cpp -D__%CPU%__ -mdfp="C:/Program Files (x86)/Microchip/MPLABX/v5.35/packs/Microchip/ATtiny_DFP/2.1.63"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=default  -gdwarf-3 -Wa,--defsym=__MPLAB_BUILD=1
set linker_args=-mcpu=%CPU% -DXPRJ_default=default -Wl,-Map=output.map -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="C:/Program Files (x86)/Microchip/MPLABX/v5.35/packs/Microchip/ATtiny_DFP/2.1.63"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -Wall -gdwarf-3  -Wl,--start-group  -Wl,-lm -Wl,--end-group 

set linker_args_with_map=%linker_args_map% -Wl,-Map=project.map
 

rem COMPILE

set compiler=xc8-cc.exe
set assembler=xc8-cc.exe
set linker=xc8-cc.exe

set project_dir=./project.X
set build_dir=%project_dir%/build

"%cpath%\%compiler%" %compiler_args% %project_dir%/mcc_generated_files/src/pin_manager.c -o %build_dir%/pin_manager.o
"%cpath%\%compiler%" %compiler_args% %project_dir%/mcc_generated_files/device_config.c -o %build_dir%/device_config.o
"%cpath%\%compiler%" %compiler_args% %project_dir%/mcc_generated_files/mcc.c -o %build_dir%/mcc.o
"%cpath%\%compiler%" %compiler_args% %project_dir%/main.c -o %build_dir%/main.o
"%cpath%\%compiler%" %compiler_args% %project_dir%/OWI_common/OWIcrc.c -o %build_dir%/OWIcrc.o
"%cpath%\%compiler%" %compiler_args% %project_dir%/OWI_polled_uart/OWIHighLevelFunctions.c -o %build_dir%/OWIHighLevelFunctions.o
"%cpath%\%compiler%" %compiler_args% %project_dir%/OWI_polled_uart/OWIUARTBitFunctions.c -o %build_dir%/OWIUARTBitFunctions.o

"%cpath%\%assembler%" %assembler_args% %project_dir%/mcc_generated_files/src/protected_io.S -o %build_dir%/protected_io.o


"%cpath%\%linker%" %linker_args% %build_dir%/main.o %build_dir%/mcc.o %build_dir%/device_config.o %build_dir%/protected_io.o %build_dir%/pin_manager.o %build_dir%/OWIcrc.o %build_dir%/OWIHighLevelFunctions.o %build_dir%/OWIUARTBitFunctions.o -o project.elf

set OBJCOPY="c:\Program Files (x86)\Microchip\xc8\v2.10\avr\bin\avr-objcopy.exe"
%OBJCOPY% -O ihex project.elf project.hex

set OBJDUMP="c:\Program Files (x86)\Microchip\xc8\v2.10\avr\bin\avr-objdump.exe"
%OBJDUMP% -S --disassemble project.elf > project.lst
 
rem del *.map
del *.asm
del *.sdf
del *.pwi
del *.dbk
del *.o
del *.d