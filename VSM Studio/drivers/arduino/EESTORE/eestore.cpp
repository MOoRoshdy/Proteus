// Wrapper for the EEPROM storage

#pragma once

#include <Core.h>
#include <eeprom.h>
#include "eestore.h"

EESTORE EEstore;

EESTORE::EESTORE () 
 { rewind(0);
 }

// Start a new putlist.
// The first two bytes are set to 'LX'  to indicate we have valid data.
EEputList &EEputList::begin () {
   EEPROM.update(addr++, 'L');
   EEPROM.update(addr++, 'X');
   return *this;
} 

// Write a constant string to the storage.
EEputList &EEputList::arg(const char *s) {
   uint16_t len = strlen(s);
   EEPROM.put(addr, len); addr += sizeof(len);
   while (*s)
      EEPROM.update(addr++, *s++);
   return *this;      
}

// Write a string object to the storage.
EEputList &EEputList::arg(const String &s) {
   uint16_t len = s.length();
   EEPROM.put(addr, len); 
   addr += sizeof(len);
   for (int16_t i=0; i<len; ++i)
      EEPROM.update(addr++, s.charAt(i));      
   return *this;            
}
 
   
// Start reading at the current address
// If the first byte is not zero, there is no valid data.
EEgetList &EEgetList::begin() {
   if (valid())
      addr += 2;
   else      
      addr = 0; // signal no data
   return *this;      
}   

// Read a string object from the storage: 
EEgetList &EEgetList::arg(String &s) {
   if (addr != 0) {
      uint16_t len;
      EEPROM.get(addr, len);
      addr += sizeof(len);
      s = (char *)0;
      s.reserve(len);
      for (int16_t i=0; i<len; ++i) {
         char c = EEPROM.read(addr++);
         s += c;
      }      
   }      
   return *this;      
}    

// Check if the data at the current address is valid. 
bool EEgetList::valid() {
   return EEPROM.read(addr) == 'L' && EEPROM.read(addr+1) == 'X'; 
}   
