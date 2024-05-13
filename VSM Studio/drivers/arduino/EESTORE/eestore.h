// Wrapper for the I2C port

#pragma once

#include <core.h>
#include <eeprom.h>

class EEputList
 { public:
      void rewind(uint16_t a) { addr = a; }
      EEputList &begin();
      template<typename T> EEputList &arg(T t) { EEPROM.put(addr, t); addr+=sizeof(t); return *this; }
      EEputList &arg(const char *s);
      EEputList &arg(const String &);
      void end() {}
   private:
      uint16_t addr;
 };


class EEgetList
 { public:
      void rewind(uint16_t a) { addr = a; }
      EEgetList &begin();
      template<typename T> EEgetList &arg(T &t) { if (addr) { t=EEPROM.get(addr, t); addr+=sizeof(t); } return *this; }
      EEgetList &arg(String &);
      void end() {}
      bool valid();
   private:      
      uint16_t addr;      
 };
     
class EESTORE
 { public:      
      EESTORE ();
      bool operator() () { return getList.valid();  }
      void rewind(uint16_t a) { putList.rewind(a); getList.rewind(a); }
      EEputList &put() { return putList.begin(); }
      EEgetList &get() { return getList.begin(); }
      void write(uint16_t addr, uint8_t data) { EEPROM.write(addr, data); }
      uint8_t read(uint16_t addr) { return EEPROM.read(addr); }
      
   private:
      EEputList putList;
      EEgetList getList;
            
 };       

extern EESTORE EEstore;

