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
ifeq "$(wildcard nbproject/Makefile-local-Release.mk)" "nbproject/Makefile-local-Release.mk"
include nbproject/Makefile-local-Release.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=Release
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
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
SOURCEFILES_QUOTED_IF_SPACED=../src/bod.c ../src/clkctrl.c ../src/cpuint.c ../src/driver_init.c ../src/protected_io.S ../src/rtc.c ../src/slpctrl.c ../atmel_start.c ../driver_isr.c ../main.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/1360937237/bod.o ${OBJECTDIR}/_ext/1360937237/clkctrl.o ${OBJECTDIR}/_ext/1360937237/cpuint.o ${OBJECTDIR}/_ext/1360937237/driver_init.o ${OBJECTDIR}/_ext/1360937237/protected_io.o ${OBJECTDIR}/_ext/1360937237/rtc.o ${OBJECTDIR}/_ext/1360937237/slpctrl.o ${OBJECTDIR}/_ext/1472/atmel_start.o ${OBJECTDIR}/_ext/1472/driver_isr.o ${OBJECTDIR}/_ext/1472/main.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/1360937237/bod.o.d ${OBJECTDIR}/_ext/1360937237/clkctrl.o.d ${OBJECTDIR}/_ext/1360937237/cpuint.o.d ${OBJECTDIR}/_ext/1360937237/driver_init.o.d ${OBJECTDIR}/_ext/1360937237/protected_io.o.d ${OBJECTDIR}/_ext/1360937237/rtc.o.d ${OBJECTDIR}/_ext/1360937237/slpctrl.o.d ${OBJECTDIR}/_ext/1472/atmel_start.o.d ${OBJECTDIR}/_ext/1472/driver_isr.o.d ${OBJECTDIR}/_ext/1472/main.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/1360937237/bod.o ${OBJECTDIR}/_ext/1360937237/clkctrl.o ${OBJECTDIR}/_ext/1360937237/cpuint.o ${OBJECTDIR}/_ext/1360937237/driver_init.o ${OBJECTDIR}/_ext/1360937237/protected_io.o ${OBJECTDIR}/_ext/1360937237/rtc.o ${OBJECTDIR}/_ext/1360937237/slpctrl.o ${OBJECTDIR}/_ext/1472/atmel_start.o ${OBJECTDIR}/_ext/1472/driver_isr.o ${OBJECTDIR}/_ext/1472/main.o

# Source Files
SOURCEFILES=../src/bod.c ../src/clkctrl.c ../src/cpuint.c ../src/driver_init.c ../src/protected_io.S ../src/rtc.c ../src/slpctrl.c ../atmel_start.c ../driver_isr.c ../main.c



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
	${MAKE}  -f nbproject/Makefile-Release.mk dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=ATtiny1607
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1360937237/bod.o: ../src/bod.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/bod.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/bod.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/bod.o.d" -MT "${OBJECTDIR}/_ext/1360937237/bod.o.d" -MT ${OBJECTDIR}/_ext/1360937237/bod.o -o ${OBJECTDIR}/_ext/1360937237/bod.o ../src/bod.c 
	
${OBJECTDIR}/_ext/1360937237/clkctrl.o: ../src/clkctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/clkctrl.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/clkctrl.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/clkctrl.o.d" -MT "${OBJECTDIR}/_ext/1360937237/clkctrl.o.d" -MT ${OBJECTDIR}/_ext/1360937237/clkctrl.o -o ${OBJECTDIR}/_ext/1360937237/clkctrl.o ../src/clkctrl.c 
	
${OBJECTDIR}/_ext/1360937237/cpuint.o: ../src/cpuint.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/cpuint.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/cpuint.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/cpuint.o.d" -MT "${OBJECTDIR}/_ext/1360937237/cpuint.o.d" -MT ${OBJECTDIR}/_ext/1360937237/cpuint.o -o ${OBJECTDIR}/_ext/1360937237/cpuint.o ../src/cpuint.c 
	
${OBJECTDIR}/_ext/1360937237/driver_init.o: ../src/driver_init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/driver_init.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/driver_init.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/driver_init.o.d" -MT "${OBJECTDIR}/_ext/1360937237/driver_init.o.d" -MT ${OBJECTDIR}/_ext/1360937237/driver_init.o -o ${OBJECTDIR}/_ext/1360937237/driver_init.o ../src/driver_init.c 
	
${OBJECTDIR}/_ext/1360937237/rtc.o: ../src/rtc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/rtc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/rtc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/rtc.o.d" -MT "${OBJECTDIR}/_ext/1360937237/rtc.o.d" -MT ${OBJECTDIR}/_ext/1360937237/rtc.o -o ${OBJECTDIR}/_ext/1360937237/rtc.o ../src/rtc.c 
	
${OBJECTDIR}/_ext/1360937237/slpctrl.o: ../src/slpctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/slpctrl.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/slpctrl.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/slpctrl.o.d" -MT "${OBJECTDIR}/_ext/1360937237/slpctrl.o.d" -MT ${OBJECTDIR}/_ext/1360937237/slpctrl.o -o ${OBJECTDIR}/_ext/1360937237/slpctrl.o ../src/slpctrl.c 
	
${OBJECTDIR}/_ext/1472/atmel_start.o: ../atmel_start.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1472" 
	@${RM} ${OBJECTDIR}/_ext/1472/atmel_start.o.d 
	@${RM} ${OBJECTDIR}/_ext/1472/atmel_start.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1472/atmel_start.o.d" -MT "${OBJECTDIR}/_ext/1472/atmel_start.o.d" -MT ${OBJECTDIR}/_ext/1472/atmel_start.o -o ${OBJECTDIR}/_ext/1472/atmel_start.o ../atmel_start.c 
	
${OBJECTDIR}/_ext/1472/driver_isr.o: ../driver_isr.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1472" 
	@${RM} ${OBJECTDIR}/_ext/1472/driver_isr.o.d 
	@${RM} ${OBJECTDIR}/_ext/1472/driver_isr.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1472/driver_isr.o.d" -MT "${OBJECTDIR}/_ext/1472/driver_isr.o.d" -MT ${OBJECTDIR}/_ext/1472/driver_isr.o -o ${OBJECTDIR}/_ext/1472/driver_isr.o ../driver_isr.c 
	
${OBJECTDIR}/_ext/1472/main.o: ../main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1472" 
	@${RM} ${OBJECTDIR}/_ext/1472/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/1472/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1472/main.o.d" -MT "${OBJECTDIR}/_ext/1472/main.o.d" -MT ${OBJECTDIR}/_ext/1472/main.o -o ${OBJECTDIR}/_ext/1472/main.o ../main.c 
	
else
${OBJECTDIR}/_ext/1360937237/bod.o: ../src/bod.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/bod.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/bod.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/bod.o.d" -MT "${OBJECTDIR}/_ext/1360937237/bod.o.d" -MT ${OBJECTDIR}/_ext/1360937237/bod.o -o ${OBJECTDIR}/_ext/1360937237/bod.o ../src/bod.c 
	
${OBJECTDIR}/_ext/1360937237/clkctrl.o: ../src/clkctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/clkctrl.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/clkctrl.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/clkctrl.o.d" -MT "${OBJECTDIR}/_ext/1360937237/clkctrl.o.d" -MT ${OBJECTDIR}/_ext/1360937237/clkctrl.o -o ${OBJECTDIR}/_ext/1360937237/clkctrl.o ../src/clkctrl.c 
	
${OBJECTDIR}/_ext/1360937237/cpuint.o: ../src/cpuint.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/cpuint.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/cpuint.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/cpuint.o.d" -MT "${OBJECTDIR}/_ext/1360937237/cpuint.o.d" -MT ${OBJECTDIR}/_ext/1360937237/cpuint.o -o ${OBJECTDIR}/_ext/1360937237/cpuint.o ../src/cpuint.c 
	
${OBJECTDIR}/_ext/1360937237/driver_init.o: ../src/driver_init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/driver_init.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/driver_init.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/driver_init.o.d" -MT "${OBJECTDIR}/_ext/1360937237/driver_init.o.d" -MT ${OBJECTDIR}/_ext/1360937237/driver_init.o -o ${OBJECTDIR}/_ext/1360937237/driver_init.o ../src/driver_init.c 
	
${OBJECTDIR}/_ext/1360937237/rtc.o: ../src/rtc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/rtc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/rtc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/rtc.o.d" -MT "${OBJECTDIR}/_ext/1360937237/rtc.o.d" -MT ${OBJECTDIR}/_ext/1360937237/rtc.o -o ${OBJECTDIR}/_ext/1360937237/rtc.o ../src/rtc.c 
	
${OBJECTDIR}/_ext/1360937237/slpctrl.o: ../src/slpctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/slpctrl.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/slpctrl.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/slpctrl.o.d" -MT "${OBJECTDIR}/_ext/1360937237/slpctrl.o.d" -MT ${OBJECTDIR}/_ext/1360937237/slpctrl.o -o ${OBJECTDIR}/_ext/1360937237/slpctrl.o ../src/slpctrl.c 
	
${OBJECTDIR}/_ext/1472/atmel_start.o: ../atmel_start.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1472" 
	@${RM} ${OBJECTDIR}/_ext/1472/atmel_start.o.d 
	@${RM} ${OBJECTDIR}/_ext/1472/atmel_start.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1472/atmel_start.o.d" -MT "${OBJECTDIR}/_ext/1472/atmel_start.o.d" -MT ${OBJECTDIR}/_ext/1472/atmel_start.o -o ${OBJECTDIR}/_ext/1472/atmel_start.o ../atmel_start.c 
	
${OBJECTDIR}/_ext/1472/driver_isr.o: ../driver_isr.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1472" 
	@${RM} ${OBJECTDIR}/_ext/1472/driver_isr.o.d 
	@${RM} ${OBJECTDIR}/_ext/1472/driver_isr.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1472/driver_isr.o.d" -MT "${OBJECTDIR}/_ext/1472/driver_isr.o.d" -MT ${OBJECTDIR}/_ext/1472/driver_isr.o -o ${OBJECTDIR}/_ext/1472/driver_isr.o ../driver_isr.c 
	
${OBJECTDIR}/_ext/1472/main.o: ../main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1472" 
	@${RM} ${OBJECTDIR}/_ext/1472/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/1472/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -std=gnu99     -MD -MP -MF "${OBJECTDIR}/_ext/1472/main.o.d" -MT "${OBJECTDIR}/_ext/1472/main.o.d" -MT ${OBJECTDIR}/_ext/1472/main.o -o ${OBJECTDIR}/_ext/1472/main.o ../main.c 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1360937237/protected_io.o: ../src/protected_io.S  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/protected_io.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/protected_io.o 
	${MP_CC} -c $(MP_EXTRA_AS_PRE) -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x assembler-with-cpp -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  -std=gnu99 -gdwarf-3 -Wa,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1   -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/protected_io.o.d" -MT "${OBJECTDIR}/_ext/1360937237/protected_io.o.d" -MT ${OBJECTDIR}/_ext/1360937237/protected_io.o -o ${OBJECTDIR}/_ext/1360937237/protected_io.o  ../src/protected_io.S 
	
else
${OBJECTDIR}/_ext/1360937237/protected_io.o: ../src/protected_io.S  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/protected_io.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/protected_io.o 
	${MP_CC} -c $(MP_EXTRA_AS_PRE) -mcpu=$(MP_PROCESSOR_OPTION)  -x assembler-with-cpp -D__$(MP_PROCESSOR_OPTION)__    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -DXPRJ_Release=$(CND_CONF)  -std=gnu99 -gdwarf-3 -Wa,--defsym=__MPLAB_BUILD=1   -MD -MP -MF "${OBJECTDIR}/_ext/1360937237/protected_io.o.d" -MT "${OBJECTDIR}/_ext/1360937237/protected_io.o.d" -MT ${OBJECTDIR}/_ext/1360937237/protected_io.o -o ${OBJECTDIR}/_ext/1360937237/protected_io.o  ../src/protected_io.S 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_Release=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1     -gdwarf-2 -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -std=gnu99 -gdwarf-3     $(COMPARISON_BUILD) -Wl,--memorysummary,dist/${CND_CONF}/${IMAGE_TYPE}/memoryfile.xml -o dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1
	@${RM} dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.hex 
	
else
dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.map  -DXPRJ_Release=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1    -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -I"../include" -I"../utils" -I"../utils/assembler" -I"../" -I"../Config" -Wall -std=gnu99 -gdwarf-3     $(COMPARISON_BUILD) -Wl,--memorysummary,dist/${CND_CONF}/${IMAGE_TYPE}/memoryfile.xml -o dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
	${MP_CC_DIR}\\avr-objcopy -O ihex "dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "dist/${CND_CONF}/${IMAGE_TYPE}/Advanced_Keypad.X.${IMAGE_TYPE}.hex"
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/Release
	${RM} -r dist/Release

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
