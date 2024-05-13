#pragma once

#include <Wire.h>
#include <SPI.h>
#include <Adafruit_BME280.h>
#include <Adafruit_Sensor.h>

#ifndef __ADAFRUIT_BME280_H__
#define __ADAFRUIT_BME280_H__

class BME280 : public Adafruit_BME280
 { public:
      bool operator()(float trigger)                                           { return readPressure() >= trigger; }
      // These functions are wrapped here as we want the Pressure value in 
      // hPa not in Pa, for consistence with BME280 active component setting.  
      float readPressure(void)                                                 { return Adafruit_BME280::readPressure()/100.0; }
      float readAltitude(float seaLevel=1013.25)                               { return Adafruit_BME280::readAltitude(seaLevel); }
      float readSealevelPressure(float altitude=0.0,float seaLevel=1013.25)    { return (float) Adafruit_BME280::seaLevelForAltitude(altitude,seaLevel); }
 };
 
#endif
