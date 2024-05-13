// Wrapper for the Yun MQTT library

#ifndef __MQTT_H__
#define __MQTT_H__

#pragma once

#include <core.h>
#include <BridgeClient.h>
#include <PubSubClient.h>

class Mqtt : public PrintList { 
   public:    
      void begin(const char *clientId,  const char *server, int port, const char *login, const char *passwd);
      void poll();

      void setWillMessage(const String &willTopic, int willRetain, const String &willMessage);
      
      void setClientId(const char *clientId);
      void connect(bool cleanSession);
      void disconnect();
      void subscribe(const String &topic, int qos);
      void unsubscribe(const String &topic);
      
      void publishRaw(const String &topic, bool retained, const String &message);

      bool operator()(const String &topic);
      String readMessage();
      String readTopic();
      StreamList &readList();

      PrintList &publish(const String &topic, bool retained);
      void end();

      static Mqtt instance;

      static void attachConnectHandler(void (*isr)()) { connectHandler=isr;  }
      static void attachMessageHandler(void (*isr)()) { messageHandler=isr;  }
      static void mqttCallback(char* topic, byte* payload, unsigned int length);

   private: 
      static BridgeClient tcpClient;
      static PubSubClient pubSubClient;
      static void (*connectHandler)();
      static void (*messageHandler)();

      //Connect params - passed into begin and retained
      const char *connectClientID;
      const char *connectUsername;
      const char *connectPassword;   
      bool connected = false;

      // Additional parameters for the will message
      String connectWillTopic;
      int connectWillQoS;
      int connectWillRetain;
      String connectWillMessage;

      //Publish vars for when ::end is called
      const char* publishTopic;
      bool publishRetained;
      PrintBuffer publishBuffer;

      // Vars for callback/message parsing:
      StreamBuffer callbackStream;
      StreamList callbackList;
      String callbackTopic;
      String callbackMessage;
      
      // Var for reconnecting:
      bool storeCleanSession = false;

};   



#endif