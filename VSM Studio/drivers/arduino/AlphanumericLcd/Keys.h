#pragma once

#include <arduino.h>

class LCDKeypad
 { public:
   LCDKeypad (){}
   int readKey(){
      adc_key_in = analogRead(0);
      if (adc_key_in > 1000) return 0;
      if (adc_key_in < 50)   return 1;
      if (adc_key_in < 250)  return 2;
      if (adc_key_in < 450)  return 3;
      if (adc_key_in < 650)  return 4;
      if (adc_key_in < 850)  return 5;
      return -1;
      
   }
      
   private:
      int adc_key_in;
   
};
