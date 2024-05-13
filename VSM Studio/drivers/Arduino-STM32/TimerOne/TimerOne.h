#ifndef TIMERONE_h
#define TIMERONE_h

#include <HardwareTimer.h>

class TimerOne
{
public:
   TimerOne();
  
   // Properties
   long timerPeriod = 1000000;

   // Methods
   void initialize(long microseconds=1000000);
   void start();
   void stop();
   void restart();
   void resume();
   unsigned long read();
   void pwm(char pin, int duty, long microseconds=-1);
   void disablePwm(char pin);
   void attachInterrupt(void (*isr)(), long microseconds=-1);
   void detachInterrupt();
   void setPeriod(long microseconds);
   void setPwmDuty(char pin, int duty);
   void (*isrCallback)();

private:
   int getChannel(int pin);

private:
   HardwareTimer timer;
};

extern TimerOne Timer_1;
#endif