import mqtt.client as mqtt
from time import sleep
from ReadList import ReadList

class MQTT:
   
   mqttc                   = None
   connectEventHandler     = None
   messageEventHandler     = None
   
   connectionFlag = False
   cleanSession = None
   
   clientId = None
   server   = None
   port     = None
   username = None
   password = None
   
   willTopic   = None
   willMessage = None
   willQOS     = None
   willRetain      = None
   
   def __call__(self, newTopic):
      global topic
      result = (topic == newTopic)
      return(result)
   
   def begin(self, id, server, port, username, password):
      
      #Passing in config variables
      
      #Solving for no name
      if id == "":
         id = None
      
      self.clientId  = id
      self.server    = server
      self.port      = port
      self.username  = username
      self.password  = password
   
   def setClientId(self, id):
      self.clientId  = id
   
   
   # Setting up the event handlers
   def attachConnectHandler(self, handler):
      global connectEventHandler
      connectEventHandler = handler
      
   def attachMessageHandler(self, handler):
      global messageEventHandler
      messageEventHandler = handler
       
   def connect(self, CleanSession=True):
      def onConnect(mqttc, obj, flags, rc):
         global connectEventHandler
         connectEventHandler()
      
      def onMessage(mqttc, obj, msg):
         global messageEventHandler
         global message
         global topic
         message = str(msg.payload)[2:-1]
         topic = msg.topic
         messageEventHandler()
         
      def onDisconnect(mqttc, obj, rc):
         global connectionFlag
         global cleanSession
         if connectionFlag:
            global connect
            print("Disconnected from server, attempting reconnect")
            connect(cleanSession)

      #Tell the program we want to connect
      global connectionFlag
      global cleanSession
      connectionFlag = True
      cleanSession = CleanSession
      
      #Setup the MQTT object
      self.mqttc = mqtt.Client(client_id=self.clientId, clean_session=CleanSession)
      
      if (self.username != None):
         self.mqttc.username_pw_set(self.username, self.password)
      
      if (self.willTopic != None):
         self.mqttc.will_set(self.willTopic, self.willMessage, self.willQOS, self.willRetain)
      
      self.mqttc.on_connect      = onConnect
      self.mqttc.on_message      = onMessage
      self.mqttc.on_disconnect   = onDisconnect
      
      self.mqttc.connect(self.server, self.port)
      self.mqttc.loop_start()

   def setWillMessage(self, Topic, QOS, Retain, *messageText):
      #Creating the object then calling connect
      self.willTopic    = Topic
      self.willQOS      = QOS
      self.willRetain       = Retain
      
      try:
         newMessage = ''
         
         for i in range(len(messageText)):
            #Adds seperator
            if i > 0:
               newMessage += ','
            #Deals with bool
            if str([messageText[i]]) == "[True]":
               newMessage += '1'
               
            elif str([messageText[i]]) == "[False]":
               newMessage += '0'
            #Deals with strings
            elif isinstance(messageText[i], str):
               newMessage += '"' + messageText[i] + '"'
            #Deals with ints and floats
            else:
               newMessage += str(messageText[i])
         
         self.willMessage = newMessage
         
      except Exception as e:
         print("Issue with list ",e)
         self.willMessage = ''
      
   def subscribe(self, Topic, QOSChannel):
      try:
         self.mqttc.subscribe(Topic, QOSChannel)
      except:
         print("Client not connected to a broker")
   
   def readMessage(self):
      global message
      return(message)
      
   def readList(self, output=[]):
      global message
      pos = 0
      size = len(message)
      def readMessage():
         global message
         nonlocal pos
         nonlocal size
         if pos >= size:
            return None
         result = message[pos]
         pos += 1
         return result
      list = ReadList(readMessage)
      list.setDelimiter(",")
      list.read(output)
      
   def readTopic(self):
      global topic
      return(topic)
      
   def publish(self, topic, QOSChannel, Retain, *messageText):
      try:
         newMessage = ''
         
         for i in range(len(messageText)):
            #Adds seperator
            if i > 0:
               newMessage += ','
            #Deals with bool
            if str([messageText[i]]) == "[True]":
               newMessage += '1'
               
            elif str([messageText[i]]) == "[False]":
               newMessage += '0'
            #Deals with strings
            elif isinstance(messageText[i], str):
               newMessage += '"'+messageText[i]+'"'
            #Deals with ints and floats
            else:
               newMessage += str(messageText[i])
         
         infot = self.mqttc.publish(topic, newMessage, qos=QOSChannel, retain=Retain)
         
      except Exception as e:
         print("Client not connected to a broker: ",e)
         
         
   def publishRaw(self, topic, QOSChannel, Retain, messageText):
      try:
 
         infot = self.mqttc.publish(topic, messageText, qos=QOSChannel, retain=Retain)
         
      except Exception as e:
         print("Client not connected to a broker: ",e)
   
   def readStoredMessage(self, value):
      pass #Leave for now. May not be needed
   
   def unsubscribe(self, Topic):
      try:
         self.mqttc.unsubscribe(Topic)
      except:
         print("Client not connected to a broker")
   
   def disconnect(self):
      global connectionFlag
      connectionFlag = False
      try:
         self.mqttc.disconnect()
      except:
         print("Client not connected to a broker")