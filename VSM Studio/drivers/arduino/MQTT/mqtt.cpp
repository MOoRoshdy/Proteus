
   
#include "mqtt.h"


// Globals
 Mqtt Mqtt::instance;
 BridgeClient Mqtt::tcpClient;
 PubSubClient Mqtt::pubSubClient(Mqtt::tcpClient);


 void (*Mqtt::messageHandler)();
 void (*Mqtt::connectHandler)();

#define DEBUG MQTT_DEBUG

void Mqtt::setClientId (const char *clientId) {
   // Store the connect parameters for future use:
   connectClientID = clientId;

}

void Mqtt::begin (const char *clientId, const char *server, int port, const char *user, const char *passwd) {
   // Store the connect parameters for future use:
   connectClientID = clientId;
   connectUsername = *user ? user : NULL;
   connectPassword = *passwd ? passwd : NULL;   

   // Set delimiters for the lists.
   setDelimiter(',');
   callbackList.setDelimiter(',');

   // Set Port and Callback Function
   pubSubClient.setServer(server, port);
	pubSubClient.setCallback(mqttCallback);
   
   pubSubClient.setKeepAlive(10);
   pubSubClient.setSocketTimeout (10);
   
	Bridge.begin();

   #if DEBUG
   Console.begin();
   #endif

}

//Set will message for connection if required
 void Mqtt::setWillMessage(const String &willTopic, int willRetain, const String &willMessage) {
   connectWillTopic = willTopic; 
   connectWillRetain = willRetain;
   connectWillMessage = willMessage;
}



//Connect to mqtt server - legacy version
 void Mqtt::connect(bool cleanSession) {
   
   storeCleanSession = cleanSession;
   
   if (!pubSubClient.connected()) {
      #if DEBUG
      Console.println(F("Attempting MQTT Connection..."));
      #endif

      // These values need to be NULL if not set:
      const char* willTopic = (connectWillTopic.length() > 0) ? connectWillTopic.c_str(): 0;
      const char* willMessage = (connectWillMessage.length() > 0) ? connectWillMessage.c_str() : 0;
      
	 	// Attempt to connect to server
	 	connected = pubSubClient.connect(connectClientID, connectUsername, connectPassword, 
                                       willTopic, 0, connectWillRetain, willMessage, 
                                       cleanSession);
     if (connected) {
         #if DEBUG
   		   Console.println(F("Connected to MQTT Server"));
         #endif
	 	   if (connectHandler != NULL)
            (*connectHandler)();
      } else {
         #if DEBUG
   		   Console.print(F("failed, rc="));
	      Console.print(pubSubClient.state());
         #endif
    	}
   }
}

//Disconnect from mqtt server
 void Mqtt::disconnect() {
	pubSubClient.disconnect();
   connected = false;

	if(pubSubClient.state() == -1) {
      #if DEBUG
      Console.println(F("MQTT Disconnected Successfully"));
      #endif
	} else {
      #if DEBUG
      Console.print(F("failed, rc="));			   
      Console.println(pubSubClient.state());
      #endif
	}
}

//Subscribe to a mqtt topic
 void Mqtt::subscribe(const String &topic, int qos) {
	pubSubClient.subscribe(topic.c_str(), qos);

   #if DEBUG
    Console.print(F("Subscribed to: "));
    Console.print(topic);
    Console.println();
   #endif
}

 void Mqtt::unsubscribe(const String &topic) {
	pubSubClient.unsubscribe(topic.c_str());

   #if DEBUG
   Console.print(F("Unsubscribed from: "));
   Console.print(topic);
   Console.println();
   #endif
}

 void Mqtt::publishRaw(const String &topic, bool retained, const String &message) {
    pubSubClient.publish(topic.c_str(), message.c_str(), retained);
}

//Add variables to class so they can be used in ::end()
 PrintList &Mqtt::publish(const String &topic, bool retained) {
   publishTopic = topic.c_str();
   publishRetained = retained;
	return PrintList::begin(false, &publishBuffer);
}

//publish message to topic
//reset retained flag just in case it was true
//clear buffer to prevent the variable from stacking messages
//trigger publish handler
 void Mqtt::end() {
   pubSubClient.publish(publishTopic, publishBuffer.buffer().c_str(), publishRetained);
   publishRetained = false;
   publishBuffer.clear();
}

 void Mqtt::mqttCallback(char* topic, byte* payload, unsigned int length) {

   payload[length] = '\0';
   instance.callbackTopic = topic;
	instance.callbackMessage = (char *)payload;

   instance.callbackStream.setBuffer((char *)payload, length);

   #if DEBUG
   Console.print(F("Message arrived ["));
   Console.print(topic);
   Console.print(F("] "));
   Console.print(instance.readMessage());
   Console.println();
   #endif
	
	if(messageHandler != NULL)
		messageHandler();
}

//Return true if topic is the same as received
 bool Mqtt::operator()(const String &topic) { 
   return (topic == callbackTopic) ? true : false;
}

 String Mqtt::readMessage() {
	return callbackMessage;
}

 StreamList &Mqtt::readList () {
  return callbackList.begin(&callbackStream);
}

 String Mqtt::readTopic() {
	return callbackTopic;
}

// Loop function
 void Mqtt::poll() {
   if (connected && !pubSubClient.connected()) {
      #if DEBUG
      Console.print(F("Disconnected attempting reconnect"));
      Console.println();
      #endif
      // If we're supposed to be connected, but not then attempt to reconnect.
      connect(storeCleanSession);
   }
	pubSubClient.loop();
}

