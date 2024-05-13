// Wrapper for the main serial port

#ifndef __UARTPORT_H__
#define __UARTPORT_H__

#pragma once

#include <Core.h>
#include <HardwareSerial.h>

class UARTPORT
 { public:
      UARTPORT (HardwareSerial &s) : serial(s) { setDelimiter(' ');}
      void setup (uint32_t baud, uint8_t config) { serial.begin(baud, config); }
      void setDelimiter(char d) { readList.setDelimiter(d); writeList.setDelimiter(d); }
      void setPlaces (uint8_t p) { printList.setPlaces(p); }
      void setBase(uint8_t b) { printList.setBase(b); }
      String input(bool echo);
      StreamList &read() { return readList.begin(&serial);  }
      PrintList &write() { return writeList.begin(false, &serial); }
      PrintList &print() { return printList.begin(false, &serial); }
      PrintList &println() { return printList.begin(true, &serial); }
      bool operator()() { return serial.available(); }
      void send (uint8_t c) { serial.print(char(c)); }
      int recv() { return serial.read(); }
      int available() { return serial.available(); }
      
   private:
      HardwareSerial &serial;
      StreamList readList;
      PrintList writeList, printList;
 };       

#if defined(BOARD_HAVE_USART1) || defined(GCM_SERCOM0_CORE)
extern UARTPORT Uart;
#endif

#if defined(HAVE_HWSERIAL1) || defined(GCM_SERCOM1_CORE)
extern UARTPORT Uart1;
#endif

#endif