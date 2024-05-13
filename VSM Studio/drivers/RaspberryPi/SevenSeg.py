import wiringpi
#import serial
import RPi.GPIO as GPIO
import time
    
class SevenSeg:

   pins = None
   
   def __init__(self, pinOne, pinTwo, pinThree, pinFour, pinFive, pinSix, pinSeven, pinEight):
      
      GPIO.setmode(GPIO.BCM)
      
      self.pins = [pinOne,pinTwo,pinThree,pinFour,pinFive,pinSix,pinSeven,pinEight]
      
      for i in range(len(self.pins)):
         GPIO.setup(self.pins[i], GPIO.OUT)
   
   characters = [
   [1,1,1,0,1,1,1,0], #A
   [0,0,1,1,1,1,1,0], #b
   [1,0,0,1,1,1,0,0], #C
   [0,1,1,1,1,0,1,0], #d
   [1,0,0,1,1,1,1,0], #E
   [1,0,0,0,1,1,1,0]  #F
   ]
   
   numbers = [
   
   [1,1,1,1,1,1,0,0], #0
   [0,1,1,0,0,0,0,0], #1
   [1,1,0,1,1,0,1,0], #2
   [1,1,1,1,0,0,1,0], #3
   [0,1,1,0,0,1,1,0], #4
   [1,0,1,1,0,1,1,0], #5
   [1,0,1,1,1,1,1,0], #6
   [1,1,1,0,0,0,0,0], #7
   [1,1,1,1,1,1,1,0], #8
   [1,1,1,0,0,1,1,0]  #9
   
   ]
   
   
   def displayCharacter(self,Character):
      
      
      for i in range(len(self.pins)-1):
         GPIO.output(self.pins[i], self.characters[Character][i])
         
   def displayInteger(self,Integer):
      
      if Integer < 0:
         Integer = 0
         print("Value too small")
      elif Integer > 9:
         Integer = 9
         print("Value too big")
      
      for i in range(len(self.pins)-1):
         GPIO.output(self.pins[i], self.numbers[Integer][i])
      
   def setDecimal(self,state):
      GPIO.output(self.pins[7], state)
         
   def setSegment(self, segment, state):
      GPIO.output(self.pins[segment-1], state)
      
   def setDisplay(self, *state):
      for i in range(len(self.pins)):
         GPIO.output(self.pins[i], state[i])
         
   def clear(self):
      for i in range(len(self.pins)):
         GPIO.output(self.pins[i], False)