#pragma once

#include <arduino.h>

enum PHANTOM_COMMANDS
{ 
   PHANTOM_CMD_NOP,   
   PHANTOM_CMD_CHECK, 
   PHANTOM_CMD_BREAK,
   PHANTOM_CMD_LOG
};

inline bool isVsm () 
{
   volatile char* PHANTOM = (char*) 0xffffff00;
   *PHANTOM = (char)PHANTOM_CMD_CHECK;
   *PHANTOM = 0x55;
   return *PHANTOM = 0xAA;  
}

inline void suspend() 
{ 
   volatile char* PHANTOM = (char*) 0xffffff00;
   *PHANTOM = (char)PHANTOM_CMD_BREAK;
}


class SimulationLog : public Print
{ 
public:
   virtual size_t write(uint8_t data) 
   { 
      volatile char* PHANTOM = (char*) 0xffffff00;
      *PHANTOM = (char)PHANTOM_CMD_LOG;
      *PHANTOM = data;
      return 1;
   }
};

extern SimulationLog SimLog;
 