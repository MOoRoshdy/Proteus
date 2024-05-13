#pragma once

#include <arduino.h>

#ifdef __AVR__
#define PHANTOM _SFR_IO8(0xDF) // Actual address is 0xFF
#endif

enum PHANTOM_COMMANDS
 { PHANTOM_CMD_NOP,   
   PHANTOM_CMD_CHECK, 
   PHANTOM_CMD_BREAK,
   PHANTOM_CMD_LOG
 };

inline bool isVsm () 
 { 
#ifdef __AVR__
   PHANTOM = PHANTOM_CMD_CHECK; 
   PHANTOM = 0x55; 
   return PHANTOM == 0xAA; 
#else
   volatile char* PHANTOM  = (char*) 0xffffff00;
   *PHANTOM = (char)PHANTOM_CMD_CHECK; 
   *PHANTOM = 0x55; 
   return *PHANTOM == 0xAA; 
#endif
 }

inline void suspend() 
 { 
#ifdef __AVR__
   PHANTOM = PHANTOM_CMD_BREAK; 
#else
   volatile char* PHANTOM  = (char*) 0xffffff00;
   *PHANTOM = (char)PHANTOM_CMD_BREAK; 
#endif
 }

class SimulationLog : public Print
 { public:
     virtual size_t write(uint8_t data) 
      { 
#ifdef __AVR__
         PHANTOM=PHANTOM_CMD_LOG; 
         PHANTOM=data; 
#else
         volatile char* PHANTOM  = (char*) 0xffffff00;
         *PHANTOM=(char)PHANTOM_CMD_LOG; 
         *PHANTOM=data; 
#endif
         return 1; 
      }
 };

 extern SimulationLog SimLog;
 