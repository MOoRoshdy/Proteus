
#include "yun.h"
#include "client.h"

using namespace Yun;

Client CLIENT;

Client::Client ()
 { request = NULL; 
 }

bool Client::begin()
// Start the bridge.
 { Bridge.begin();
 }

bool Client::doRequest(const String &action, const String &url)
 { if (request != NULL)
      delete request;
   request = new Process;
   request->begin("curl");
   request->addParameter("--request");
   request->addParameter(action);
   request->addParameter(url);
   success = request->run() == 0;
   return success;
 }


String Client::readln ()
 { String s;
   int cr;
   if (request != NULL && request->available())
    { s = request->readStringUntil('\n');
      if ((cr = s.indexOf('\r')) != -1)
         s.remove(cr);      
      success = true;
    }
   else
      success = false;
   return s;          
 }
  
