/********************************************************************/
/********************************************************************/
/*****                                                          *****/
/*****        L A B C E N T E R    E L E C T R O N I C S        *****/
/*****                                                          *****/
/*****                 Visual Designer for Arduino              *****/
/*****                                                          *****/
/*****                       Stream Buffer                       *****/
/*****                                                          *****/
/********************************************************************/
/********************************************************************/

#include <arduino.h>
#include <ctype.h>

#include "core.h"

StreamBuffer::StreamBuffer ()  {}
 
void StreamBuffer::setBuffer(char* message, unsigned int length) {
   sbMessage = message;
   sbLength = length;
   sbPosition = 0;
}
   
int StreamBuffer::available() {
   return sbLength - sbPosition; 
}

int StreamBuffer::read() {
   return sbPosition < sbLength ? sbMessage[sbPosition++] : -1; 
}

int StreamBuffer::peek() {
    return sbPosition < sbLength ? sbMessage[sbPosition] : -1; 
}

size_t StreamBuffer::write(uint8_t c) {
   sbMessage += (char)c; 
   return 1;
}

size_t StreamBuffer::write(const uint8_t *buffer, size_t size)
 { for (int i=0; i<size; ++i)
      sbMessage += (char)buffer[i];
   return size;   
 }

void StreamBuffer::flush() {
}
