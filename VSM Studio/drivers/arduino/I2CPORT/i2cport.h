// Wrapper for the I2C port

#pragma once

#include <Core.h>
#include <Wire.h>

class I2CtxList 
 { public:
      I2CtxList &begin(uint8_t addr, bool s) { Wire.beginTransmission(addr); stop=s; return *this;  }
      I2CtxList &arg(const int i) { Wire.write(i); return *this; }
      I2CtxList &arg(const char *s) { Wire.write((char *)s); return *this; }
      I2CtxList &arg(const String &s) { Wire.write((char *)s.c_str()); return *this; }
      void end() { Wire.endTransmission(stop); }
   private:
      bool stop;
 };

class I2CrxList 
 { public:
      I2CrxList &begin(uint8_t addr, uint8_t len, uint8_t stop) { Wire.requestFrom(addr, len, stop); return *this; }
      I2CrxList &arg(long &i); 
      I2CrxList &arg(float &f);
      I2CrxList &arg(String &s);
      //I2CrxList &arg(Time &t) { t=0; return *this; }
      void end() {}
 };
      
class I2CPort
 { public:      
      void begin() { Wire.begin(); }
      void setClock (long clock) { Wire.setClock(clock); }
      void setSlave (uint8_t addr) { Wire.end(); Wire.begin(addr); }
      I2CtxList &transmit(int16_t addr,  bool stop) { return txList.begin(addr, stop); }
      I2CrxList &receive(uint8_t addr, uint8_t len, bool stop) { return rxList.begin(addr, len, stop); }
   private:
      I2CtxList txList;
      I2CrxList rxList;
            
 };       

extern I2CPort I2C;

