#ifndef TIMERONE_cpp
#define TIMERONE_cpp

#include "TimerOne.h"
#include <board/board.h>       // for CYCLES_PER_MICROSECOND

TimerOne Timer_1;              // preinstatiate

TimerOne::TimerOne()
 : timer(1)
{
}

void TimerOne::initialize(long microseconds)
{
   setPeriod(microseconds);
}


void TimerOne::setPeriod(long microseconds)
{
    timerPeriod = microseconds;
    timer.setPeriod(microseconds);
}

void TimerOne::setPwmDuty(char pin, int duty)
{
   int channel = getChannel(pin);
   if (channel < 0)
      return;

   timer.pause();
   timer.setCompare(channel, timer.getOverflow() * duty / 1024);
   timer.refresh();
   timer.resume();
}

void TimerOne::pwm(char pin, int duty, long microseconds)
{
   int channel = getChannel(pin);
   if (channel < 0)
      return;   

   timer.pause();
   setPeriod(microseconds);
   timer.setMode(channel, TIMER_PWM);
   timer.setCompare(channel, timer.getOverflow() * duty / 1024);
   timer.refresh();
   timer.resume();
}

void TimerOne::disablePwm(char pin)
{
   int channel = getChannel(pin);
   if (channel < 0)
      return;

   timer.pause();
   timer.setMode(channel, TIMER_DISABLED);
   timer.refresh();
   timer.resume();
}

void TimerOne::attachInterrupt(void (*isr)(), long microseconds)
{ 
   setPeriod(microseconds);
   timer.attachInterrupt(0, isr);
}

void TimerOne::detachInterrupt()
{
   timer.detachInterrupt(0);
}

void TimerOne::resume()
{
   timer.resume();
}

void TimerOne::restart()
{
   stop();
   start();
}

void TimerOne::start()
{
   timer.resume();
}

void TimerOne::stop()
{
   timer.pause();
}

unsigned long TimerOne::read()
{
   uint16 prescaler = timer.getPrescaleFactor();
   uint32 count = timer.getCount();
   
   uint32 count_cyc = count * prescaler - prescaler / 2;
   
   return count_cyc / CYCLES_PER_MICROSECOND;
}

int TimerOne::getChannel(int pin)
{
   switch (pin)
   {
      case PA8:
         return TIMER_CH1;
      case PA9:
         return TIMER_CH2;
      case PA10:
         return TIMER_CH3;
      case PA11:
         return TIMER_CH4;
   }
   return -1; // Wrong pin number
}

#endif