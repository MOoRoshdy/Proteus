AVR807: Manchester Encoder Using USART and CCL with ATtiny807 
=================================================================

This application note shows manchester encoder using USART and CCL based on ATtiny807 device.

For more detailed description, please see the applicaiton note available from:
TBD

FUSE SETTING
========================
1. Select internal oscillator 20MHz

INTERFACE SETTING
========================
PA4: LUT0 OUT
PB1: USART XCK
PB2: USART TXD

SUPPORTED EVALUATION KIT
========================
ATtiny807 Xplained Mini

RUNNING THE DEMO
================
1. Download the example .atzip file from Atmel|START
2. if with Atmel Studio 7 (or later), import .atzip file into Atmel Studio 7, File->Import->Atmel Start Project
   if with IAR 6.80(or later), unzip the .atzip file to locate .eww/.ewp files, and open with IAR IDE
   IAR WORKBENCH CONFIGURATION: 
   a. Library Configuration: Normal DLIB
3. Build and flash into supported evaluation board
4. Run (debug) the code
