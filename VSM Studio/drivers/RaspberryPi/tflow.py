#! /usr/bin/env python3
# TensorFlow Visual Designer module

# Modules
import sounddevice as sd
import numpy as np
import scipy.signal
import timeit
import python_speech_features
from tflite_runtime.interpreter import Interpreter

soundListener = None

class SoundListener:
   # Parameters
   recDuration = 0.5
   windowStride = 0.5
   sampleRate = 48000
   resampleRate = 8000
   numChannels = 1
   numMfcc = 16
   debugTime = 0

   # Constructor
   def __init__(self):
      # Word recognisers list
      self.wordRecognisers = []

      # Sliding window
      self.window = np.zeros(int(self.recDuration * self.resampleRate) * 2)

      # Start streaming from microphone
      self.inputStream = sd.InputStream(channels=self.numChannels, samplerate=self.sampleRate, blocksize=int(self.sampleRate * self.recDuration), callback=self.sdCallback)
      self.inputStream.start()

   # Add word recogniser to the list
   def addRecogniser(self, wordRecogniser):
      self.wordRecognisers.append(wordRecogniser)

   # Add word recogniser to the list
   def removeRecogniser(self, wordRecogniser):
      self.wordRecognisers.remove(wordRecogniser)

   # Decimate (filter and downsample)
   def decimate(self, signal, old_fs, new_fs):
       
       # Check to make sure we're downsampling
       if new_fs > old_fs:
           print("Error: target sample rate higher than original")
           return signal, old_fs
       
       # We can only downsample by an integer factor
       dec_factor = old_fs / new_fs
       if not dec_factor.is_integer():
           print("Error: can only decimate by integer factor")
           return signal, old_fs

       # Do decimation
       resampled_signal = scipy.signal.decimate(signal, int(dec_factor))

       return resampled_signal, new_fs

   # This gets called every 0.5 seconds
   def sdCallback(self, rec, frames, time, status):

       # Start timing for testing
       start = timeit.default_timer()
       
       # Notify if errors
       if status:
           print('Error:', status)
       
       # Remove 2nd dimension from recording sample
       rec = np.squeeze(rec)
       
       # Resample
       rec, new_fs = self.decimate(rec, self.sampleRate, self.resampleRate)
       
       # Save recording onto sliding window
       self.window[:len(self.window)//2] = self.window[len(self.window)//2:]
       self.window[len(self.window)//2:] = rec

       # Compute features
       mfccs = python_speech_features.base.mfcc(self.window,
                                           samplerate=new_fs,
                                           winlen=0.256,
                                           winstep=0.050,
                                           numcep=self.numMfcc,
                                           nfilt=26,
                                           nfft=2048,
                                           preemph=0.97,
                                           ceplifter=0,
                                           appendEnergy=False,
                                           winfunc=np.hanning)
       mfccs = mfccs.transpose()

       # Make prediction from model
       inTensor = np.float32(mfccs.reshape(1, mfccs.shape[0], mfccs.shape[1], 1))

       # Call word recognisers
       for wordRecogniser in self.wordRecognisers:
          wordRecogniser(inTensor)

       if self.debugTime:
          print(timeit.default_timer() - start)

class WordRecogniser:
   # Parameters
   wordThreshold = 0.5
   debugAcc = 0

   # Constructor
   def __init__(self, modelPath, callback = None, wordThreshold = 0.5):
      self.wordThreshold = wordThreshold

      # Recognised word callbacks
      self.callbacks = []
      # Add callback if provided
      if callback is not None:
         self.addCallback(callback)

      # Load model (interpreter)
      self.interpreter = Interpreter(modelPath)
      self.interpreter.allocate_tensors()
      self.inputDetails = self.interpreter.get_input_details()
      self.outputDetails = self.interpreter.get_output_details()

      global soundListener
      # Create sound listener if required
      if soundListener is None:
         soundListener = SoundListener()
      # Add this recogniser to the listener      
      soundListener.addRecogniser(self.recognise)

   # Destructor
   def __del__(self):
      global soundListener
      # Remove itself from the listener callbacks
      soundListener.removeRecogniser(self.recognise)
      
   # Add callback for the recognised word
   def addCallback(self, callback):
      self.callbacks.append(callback)

   # Recognition procedure
   def recognise(self, inTensor):
      self.interpreter.set_tensor(self.inputDetails[0]['index'], inTensor)
      self.interpreter.invoke()
      outputData = self.interpreter.get_tensor(self.outputDetails[0]['index'])
      val = outputData[0][0]
      if self.debugAcc:
          print(val)
      if val > self.wordThreshold:
          # Call the callbacks
          for callback in self.callbacks:
             callback()

class tflow:
   def WordRecogniser(self, modelPath, eventName):
      # Find callback function by its name from module main:
      callback = None
      main = __import__("main")
      try:
         callback = getattr(main, eventName)
      except:
         try:
            callback = getattr(main, "chart_"+eventName)
         except:
            pass
      if callback is None:
         raise Exception("Could not find event '" + eventName + "' for model '" + modelPath + "'")
      else:
         # Add word recogniser
         WordRecogniser(modelPath, callback)
