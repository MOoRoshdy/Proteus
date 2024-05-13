// Generic IR Remote
#pragma once

#include <Arduino.h>
#include <IRremote.h>

class Keyes_Remote
 { public:
      Keyes_Remote (uint8_t _pin):irrecv(_pin){
         //Initialize Variables
         pin = _pin;
      }
      
      void begin() {
         //Initialize remote after simulation initialization.
         IRrecv irrecv(pin);
         pinMode(pin, INPUT);
         irrecv.enableIRIn();  // Start the receiver
      }
      
      //Interupt when button is pressed
      void attachKeyInterruptHandler(void (*isr)()) { keyInterruptHandler = isr; }
      
      //Return the translated code
      unsigned long getCode(){return results.value;}
      
      char* getProtocol(){
        //Convert int(Type) to string
        static char protocol[20];
        switch (results.decode_type) {
          default:
          case UNKNOWN:     	strncpy(protocol,"UNKNOWN",      sizeof(protocol)-1); break ;
          case NEC:          	strncpy(protocol,"NEC",          sizeof(protocol)-1); break ;
          case SONY:         	strncpy(protocol,"SONY",         sizeof(protocol)-1); break ;
          case RC5:          	strncpy(protocol,"RC5",          sizeof(protocol)-1); break ;
          case RC6:          	strncpy(protocol,"RC6",          sizeof(protocol)-1); break ;
          case DISH:         	strncpy(protocol,"DISH",         sizeof(protocol)-1); break ;
          case SHARP:        	strncpy(protocol,"SHARP",        sizeof(protocol)-1); break ;
          case JVC:          	strncpy(protocol,"JVC",          sizeof(protocol)-1); break ;
          case SANYO:        	strncpy(protocol,"SANYO",        sizeof(protocol)-1); break ;
          case MITSUBISHI:   	strncpy(protocol,"MITSUBISHI",   sizeof(protocol)-1); break ;
          case SAMSUNG:    	strncpy(protocol,"SAMSUNG",      sizeof(protocol)-1); break ;
          case LG:            strncpy(protocol,"LG",           sizeof(protocol)-1); break ;
          case WHYNTER:     	strncpy(protocol,"WHYNTER",      sizeof(protocol)-1); break ;
          case AIWA_RC_T501:  strncpy(protocol,"AIWA_RC_T501", sizeof(protocol)-1); break ;
          case PANASONIC:    	strncpy(protocol,"PANASONIC",    sizeof(protocol)-1); break ;
          case DENON:        	strncpy(protocol,"Denon",        sizeof(protocol)-1); break ;
        }
        return protocol;
      }
      
      char* getKey(){
        //Translate hex code to respective button
        static char key[20];
        switch (results.value) {
          default:          strncpy(key,"Unknown",  sizeof(key)-1);  break;
          
          //Keyes_Remote
          case 0xFFFFFFFF:  strncpy(key,"Repeat",   sizeof(key)-1);  break;
          
          case 0xFF629D:   strncpy(key,"Up",    sizeof(key)-1); break;
          case 0xFF22DD:   strncpy(key,"Left",  sizeof(key)-1); break;
          case 0xFF02FD:   strncpy(key,"Ok",    sizeof(key)-1); break;
          case 0xFFC23D:   strncpy(key,"Right", sizeof(key)-1); break;
          case 0xFFA857:   strncpy(key,"Down",  sizeof(key)-1); break;
          
          case 0xFF6897:   strncpy(key,"1",  sizeof(key)-1); break;
          case 0xFF9867:   strncpy(key,"2",  sizeof(key)-1); break;
          case 0xFFB04F: 	strncpy(key,"3",  sizeof(key)-1); break;
          case 0xFF30CF:   strncpy(key,"4",  sizeof(key)-1); break;
          case 0xFF18E7:   strncpy(key,"5",  sizeof(key)-1); break;
          case 0xFF7A85: 	strncpy(key,"6",  sizeof(key)-1); break;
          case 0xFF10EF:   strncpy(key,"7",  sizeof(key)-1); break;
          case 0xFF38C7:   strncpy(key,"8",  sizeof(key)-1); break;
          case 0xFF5AA5: 	strncpy(key,"9",  sizeof(key)-1); break;
          case 0xFF42BD:   strncpy(key,"*",  sizeof(key)-1); break;
          case 0xFF4AB5:   strncpy(key,"0",  sizeof(key)-1); break;
          case 0xFF52AD: 	strncpy(key,"#",  sizeof(key)-1); break;
          
          
          //Samsung Remote
          case 0xE0E040BF: strncpy(key,"TV Power", sizeof(key)-1); break;
          case 0xE0E007F8: strncpy(key,"STB Power",sizeof(key)-1); break;
          case 0xE0E0807F: strncpy(key,"Source",   sizeof(key)-1); break;
          
          case 0xE0E020DF: strncpy(key,"1",        sizeof(key)-1); break;
          case 0xE0E0A05F: strncpy(key,"2",        sizeof(key)-1); break;
          case 0xE0E0609F: strncpy(key,"3",        sizeof(key)-1); break;
          case 0xE0E010EF: strncpy(key,"4",        sizeof(key)-1); break;
          case 0xE0E0906F: strncpy(key,"5",        sizeof(key)-1); break;
          case 0xE0E050AF: strncpy(key,"6",        sizeof(key)-1); break;
          case 0xE0E030CF: strncpy(key,"7",        sizeof(key)-1); break;
          case 0xE0E0B04F: strncpy(key,"8",        sizeof(key)-1); break;
          case 0xE0E0708F: strncpy(key,"9",        sizeof(key)-1); break;
          case 0xE0E034CB: strncpy(key,"TTX/MIX",  sizeof(key)-1); break;
          case 0xE0E08877: strncpy(key,"0",        sizeof(key)-1); break;
          case 0xE0E0C837: strncpy(key,"PRE-CH",   sizeof(key)-1); break;
          
          case 0xE0E0E01F: strncpy(key,"Vol Up",   sizeof(key)-1); break;
          case 0xE0E0F00F: strncpy(key,"Mute",     sizeof(key)-1); break;
          case 0xE0E048B7: strncpy(key,"Chan Up",  sizeof(key)-1); break;
          case 0xE0E0D02F: strncpy(key,"Vol Down", sizeof(key)-1); break;
          case 0xE0E0D629: strncpy(key,"CH List",  sizeof(key)-1); break;
          case 0xE0E008F7: strncpy(key,"Chan Down",sizeof(key)-1); break;
          case 0xE0E058A7: strncpy(key,"Menu",     sizeof(key)-1); break;
          case 0xE0E09E61: strncpy(key,"M",        sizeof(key)-1); break;
          case 0xE0E0F20D: strncpy(key,"Guide",    sizeof(key)-1); break;
          case 0xE0E0D22D: strncpy(key,"Tools",    sizeof(key)-1); break;
          case 0xE0E006F9: strncpy(key,"Up",       sizeof(key)-1); break;
          case 0xE0E0F807: strncpy(key,"Info",     sizeof(key)-1); break;
          case 0xE0E0A659: strncpy(key,"Left",     sizeof(key)-1); break;
          case 0xE0E016E9: strncpy(key,"Enter",    sizeof(key)-1); break;
          case 0xE0E046B9: strncpy(key,"Right",    sizeof(key)-1); break;
          case 0xE0E01AE5: strncpy(key,"Return",   sizeof(key)-1); break;
          case 0xE0E08679: strncpy(key,"Down",     sizeof(key)-1); break;
          case 0xE0E0B44B: strncpy(key,"Exit",     sizeof(key)-1); break;
          
          case 0xE0E036C9: strncpy(key,"A",     sizeof(key)-1); break;
          case 0xE0E028D7: strncpy(key,"B",     sizeof(key)-1); break;
          case 0xE0E0A857: strncpy(key,"C",     sizeof(key)-1); break;
          case 0xE0E06897: strncpy(key,"D",     sizeof(key)-1); break;
          case 0xE0E01DE2: strncpy(key,"Football",     sizeof(key)-1); break;
          case 0xE0E0CE31: strncpy(key,"Search",     sizeof(key)-1); break;
          case 0xE0E04BB4: strncpy(key,"Keypad",     sizeof(key)-1); break;
          case 0xE0E0FC03: strncpy(key,"E-Manual",     sizeof(key)-1); break;
          case 0xE0E07C83: strncpy(key,"P.Size",     sizeof(key)-1); break;
          case 0xE0E0A45B: strncpy(key,"AD/SUBT",     sizeof(key)-1); break;
          case 0xE0E0A25D: strncpy(key,"Rewind",     sizeof(key)-1); break;
          case 0xE0E052AD: strncpy(key,"Pause",     sizeof(key)-1); break;
          case 0xE0E012ED: strncpy(key,"Fastforward",     sizeof(key)-1); break;
          case 0xE0E0926D: strncpy(key,"Record",     sizeof(key)-1); break;
          case 0xE0E0E21D: strncpy(key,"Play",     sizeof(key)-1); break;
          case 0xE0E0629D: strncpy(key,"Stop",     sizeof(key)-1); break;
        }
        return key;
      }
      
      char* getRaw(){
         static char raw[350];
         int cx = 0;
         
         // Gather raw data
         for (int i = 1;  i < results.rawlen;  i++) {
            
            //snprintf converting int to string 
            cx += snprintf (raw+cx, 350-cx, "%d", (results.rawbuf[i] * USECPERTICK));
            
            if ( i < results.rawlen-1 ){
               cx += snprintf (raw+cx, 350-cx, ",");
            }
            
            if (!(i & 1)){
               cx += snprintf (raw+cx, 350-cx, " ");
            }
         }
         return raw;
       }

      void poll(){
         if (irrecv.decode(&results)) { 
            if (keyInterruptHandler != NULL) { 
               (*keyInterruptHandler)();
            }
            irrecv.resume();
         }
       }
   
   private:
      int pin;
      IRrecv irrecv;
      decode_results  results;
      void (*keyInterruptHandler)() = NULL;
 };
 