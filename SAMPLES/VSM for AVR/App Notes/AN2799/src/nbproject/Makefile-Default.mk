#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-Default.mk)" "nbproject/Makefile-local-Default.mk"
include nbproject/Makefile-local-Default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=Default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=
else
COMPARISON_BUILD=
endif

ifdef SUB_IMAGE_ADDRESS

else
SUB_IMAGE_ADDRESS_COMMAND=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=petitfs/diskio_avr.c petitfs/pff.c src/driver_init.c src/bod.c src/clkctrl.c src/cpuint.c src/protected_io.S src/slpctrl.c main.c driver_isr.c atmel_start.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/petitfs/diskio_avr.o ${OBJECTDIR}/petitfs/pff.o ${OBJECTDIR}/src/driver_init.o ${OBJECTDIR}/src/bod.o ${OBJECTDIR}/src/clkctrl.o ${OBJECTDIR}/src/cpuint.o ${OBJECTDIR}/src/protected_io.o ${OBJECTDIR}/src/slpctrl.o ${OBJECTDIR}/main.o ${OBJECTDIR}/driver_isr.o ${OBJECTDIR}/atmel_start.o
POSSIBLE_DEPFILES=${OBJECTDIR}/petitfs/diskio_avr.o.d ${OBJECTDIR}/petitfs/pff.o.d ${OBJECTDIR}/src/driver_init.o.d ${OBJECTDIR}/src/bod.o.d ${OBJECTDIR}/src/clkctrl.o.d ${OBJECTDIR}/src/cpuint.o.d ${OBJECTDIR}/src/protected_io.o.d ${OBJECTDIR}/src/slpctrl.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/driver_isr.o.d ${OBJECTDIR}/atmel_start.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/petitfs/diskio_avr.o ${OBJECTDIR}/petitfs/pff.o ${OBJECTDIR}/src/driver_init.o ${OBJECTDIR}/src/bod.o ${OBJECTDIR}/src/clkctrl.o ${OBJECTDIR}/src/cpuint.o ${OBJECTDIR}/src/protected_io.o ${OBJECTDIR}/src/slpctrl.o ${OBJECTDIR}/main.o ${OBJECTDIR}/driver_isr.o ${OBJECTDIR}/atmel_start.o

# Source Files
SOURCEFILES=petitfs/diskio_avr.c petitfs/pff.c src/driver_init.c src/bod.c src/clkctrl.c src/cpuint.c src/protected_io.S src/slpctrl.c main.c driver_isr.c atmel_start.c



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-Default.mk dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=ATtiny1607
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/petitfs/diskio_avr.o: petitfs/diskio_avr.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/petitfs" 
	@${RM} ${OBJECTDIR}/petitfs/diskio_avr.o.d 
	@${RM} ${OBJECTDIR}/petitfs/diskio_avr.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/petitfs/diskio_avr.o.d" -MT "${OBJECTDIR}/petitfs/diskio_avr.o.d" -MT ${OBJECTDIR}/petitfs/diskio_avr.o -o ${OBJECTDIR}/petitfs/diskio_avr.o petitfs/diskio_avr.c 
	
${OBJECTDIR}/petitfs/pff.o: petitfs/pff.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/petitfs" 
	@${RM} ${OBJECTDIR}/petitfs/pff.o.d 
	@${RM} ${OBJECTDIR}/petitfs/pff.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/petitfs/pff.o.d" -MT "${OBJECTDIR}/petitfs/pff.o.d" -MT ${OBJECTDIR}/petitfs/pff.o -o ${OBJECTDIR}/petitfs/pff.o petitfs/pff.c 
	
${OBJECTDIR}/src/driver_init.o: src/driver_init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/driver_init.o.d 
	@${RM} ${OBJECTDIR}/src/driver_init.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/src/driver_init.o.d" -MT "${OBJECTDIR}/src/driver_init.o.d" -MT ${OBJECTDIR}/src/driver_init.o -o ${OBJECTDIR}/src/driver_init.o src/driver_init.c 
	
${OBJECTDIR}/src/bod.o: src/bod.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/bod.o.d 
	@${RM} ${OBJECTDIR}/src/bod.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/src/bod.o.d" -MT "${OBJECTDIR}/src/bod.o.d" -MT ${OBJECTDIR}/src/bod.o -o ${OBJECTDIR}/src/bod.o src/bod.c 
	
${OBJECTDIR}/src/clkctrl.o: src/clkctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/clkctrl.o.d 
	@${RM} ${OBJECTDIR}/src/clkctrl.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/src/clkctrl.o.d" -MT "${OBJECTDIR}/src/clkctrl.o.d" -MT ${OBJECTDIR}/src/clkctrl.o -o ${OBJECTDIR}/src/clkctrl.o src/clkctrl.c 
	
${OBJECTDIR}/src/cpuint.o: src/cpuint.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/cpuint.o.d 
	@${RM} ${OBJECTDIR}/src/cpuint.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/src/cpuint.o.d" -MT "${OBJECTDIR}/src/cpuint.o.d" -MT ${OBJECTDIR}/src/cpuint.o -o ${OBJECTDIR}/src/cpuint.o src/cpuint.c 
	
${OBJECTDIR}/src/slpctrl.o: src/slpctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/slpctrl.o.d 
	@${RM} ${OBJECTDIR}/src/slpctrl.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/src/slpctrl.o.d" -MT "${OBJECTDIR}/src/slpctrl.o.d" -MT ${OBJECTDIR}/src/slpctrl.o -o ${OBJECTDIR}/src/slpctrl.o src/slpctrl.c 
	
${OBJECTDIR}/main.o: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/driver_isr.o: driver_isr.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/driver_isr.o.d 
	@${RM} ${OBJECTDIR}/driver_isr.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/driver_isr.o.d" -MT "${OBJECTDIR}/driver_isr.o.d" -MT ${OBJECTDIR}/driver_isr.o -o ${OBJECTDIR}/driver_isr.o driver_isr.c 
	
${OBJECTDIR}/atmel_start.o: atmel_start.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/atmel_start.o.d 
	@${RM} ${OBJECTDIR}/atmel_start.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/atmel_start.o.d" -MT "${OBJECTDIR}/atmel_start.o.d" -MT ${OBJECTDIR}/atmel_start.o -o ${OBJECTDIR}/atmel_start.o atmel_start.c 
	
else
${OBJECTDIR}/petitfs/diskio_avr.o: petitfs/diskio_avr.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/petitfs" 
	@${RM} ${OBJECTDIR}/petitfs/diskio_avr.o.d 
	@${RM} ${OBJECTDIR}/petitfs/diskio_avr.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/petitfs/diskio_avr.o.d" -MT "${OBJECTDIR}/petitfs/diskio_avr.o.d" -MT ${OBJECTDIR}/petitfs/diskio_avr.o -o ${OBJECTDIR}/petitfs/diskio_avr.o petitfs/diskio_avr.c 
	
${OBJECTDIR}/petitfs/pff.o: petitfs/pff.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/petitfs" 
	@${RM} ${OBJECTDIR}/petitfs/pff.o.d 
	@${RM} ${OBJECTDIR}/petitfs/pff.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/petitfs/pff.o.d" -MT "${OBJECTDIR}/petitfs/pff.o.d" -MT ${OBJECTDIR}/petitfs/pff.o -o ${OBJECTDIR}/petitfs/pff.o petitfs/pff.c 
	
${OBJECTDIR}/src/driver_init.o: src/driver_init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/driver_init.o.d 
	@${RM} ${OBJECTDIR}/src/driver_init.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/src/driver_init.o.d" -MT "${OBJECTDIR}/src/driver_init.o.d" -MT ${OBJECTDIR}/src/driver_init.o -o ${OBJECTDIR}/src/driver_init.o src/driver_init.c 
	
${OBJECTDIR}/src/bod.o: src/bod.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/bod.o.d 
	@${RM} ${OBJECTDIR}/src/bod.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/src/bod.o.d" -MT "${OBJECTDIR}/src/bod.o.d" -MT ${OBJECTDIR}/src/bod.o -o ${OBJECTDIR}/src/bod.o src/bod.c 
	
${OBJECTDIR}/src/clkctrl.o: src/clkctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/clkctrl.o.d 
	@${RM} ${OBJECTDIR}/src/clkctrl.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/src/clkctrl.o.d" -MT "${OBJECTDIR}/src/clkctrl.o.d" -MT ${OBJECTDIR}/src/clkctrl.o -o ${OBJECTDIR}/src/clkctrl.o src/clkctrl.c 
	
${OBJECTDIR}/src/cpuint.o: src/cpuint.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/cpuint.o.d 
	@${RM} ${OBJECTDIR}/src/cpuint.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/src/cpuint.o.d" -MT "${OBJECTDIR}/src/cpuint.o.d" -MT ${OBJECTDIR}/src/cpuint.o -o ${OBJECTDIR}/src/cpuint.o src/cpuint.c 
	
${OBJECTDIR}/src/slpctrl.o: src/slpctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/slpctrl.o.d 
	@${RM} ${OBJECTDIR}/src/slpctrl.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/src/slpctrl.o.d" -MT "${OBJECTDIR}/src/slpctrl.o.d" -MT ${OBJECTDIR}/src/slpctrl.o -o ${OBJECTDIR}/src/slpctrl.o src/slpctrl.c 
	
${OBJECTDIR}/main.o: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/driver_isr.o: driver_isr.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/driver_isr.o.d 
	@${RM} ${OBJECTDIR}/driver_isr.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/driver_isr.o.d" -MT "${OBJECTDIR}/driver_isr.o.d" -MT ${OBJECTDIR}/driver_isr.o -o ${OBJECTDIR}/driver_isr.o driver_isr.c 
	
${OBJECTDIR}/atmel_start.o: atmel_start.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/atmel_start.o.d 
	@${RM} ${OBJECTDIR}/atmel_start.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/atmel_start.o.d" -MT "${OBJECTDIR}/atmel_start.o.d" -MT ${OBJECTDIR}/atmel_start.o -o ${OBJECTDIR}/atmel_start.o atmel_start.c 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/src/protected_io.o: src/protected_io.S  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/protected_io.o.d 
	@${RM} ${OBJECTDIR}/src/protected_io.o 
	${MP_CC} -c $(MP_EXTRA_AS_PRE) -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x assembler-with-cpp -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  -std=gnu99 -gdwarf-3 -Wa,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1 -std=gnu99   -MD -MP -MF "${OBJECTDIR}/src/protected_io.o.d" -MT "${OBJECTDIR}/src/protected_io.o.d" -MT ${OBJECTDIR}/src/protected_io.o -o ${OBJECTDIR}/src/protected_io.o  src/protected_io.S 
	
else
${OBJECTDIR}/src/protected_io.o: src/protected_io.S  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/protected_io.o.d 
	@${RM} ${OBJECTDIR}/src/protected_io.o 
	${MP_CC} -c $(MP_EXTRA_AS_PRE) -mcpu=$(MP_PROCESSOR_OPTION)  -x assembler-with-cpp -D__$(MP_PROCESSOR_OPTION)__   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -DXPRJ_Default=$(CND_CONF)  -std=gnu99 -gdwarf-3 -Wa,--defsym=__MPLAB_BUILD=1 -std=gnu99   -MD -MP -MF "${OBJECTDIR}/src/protected_io.o.d" -MT "${OBJECTDIR}/src/protected_io.o.d" -MT ${OBJECTDIR}/src/protected_io.o -o ${OBJECTDIR}/src/protected_io.o  src/protected_io.S 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_Default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="."   -gdwarf-2 -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -std=gnu99 -gdwarf-3     $(COMPARISON_BUILD) -Wl,--memorysummary,dist/${CND_CONF}/${IMAGE_TYPE}/memoryfile.xml -o dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1
	@${RM} dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.hex 
	
else
dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.map  -DXPRJ_Default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="."  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"./." -I"include" -I"utils/assembler" -I"utils" -I"config" -Wall -std=gnu99 -gdwarf-3     $(COMPARISON_BUILD) -Wl,--memorysummary,dist/${CND_CONF}/${IMAGE_TYPE}/memoryfile.xml -o dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
	${MP_CC_DIR}\\avr-objcopy -O ihex "dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "dist/${CND_CONF}/${IMAGE_TYPE}/fs_1607.X.${IMAGE_TYPE}.hex"
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/Default
	${RM} -r dist/Default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
