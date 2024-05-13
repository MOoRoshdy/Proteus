#include "core.h"
#include "vfpserver.h"
#include "filestore.h"
#include "controls.h"

//Global define static variables
String Login::storedPassword = "";

Login::Login (const char *id): Control (id) {
}

//Called from the control.xml - Set an initial password before launch
void Login::init (String initPassword) { 
    Login::storedPassword = initPassword; 
};


//Set a new password from text input control or similar
void Login::setPassword(String newPassword) {
     Login::storedPassword = newPassword;
}


// Process arguments passed from the control.
// First arg is action: 0=login, 1=logout.
// Second arg is the password as entered by the user.
// On a sucessful login, authorize the server.
StreamList &Login::parseArgs(StreamList &request) { 
   int login = 0;
   String password;
   request.arg(login).arg(password);

   if (login) {
      if (password == storedPassword) 
         VFP.authorize(true);
      else 
         VFP.call(id, F("authError")).end();
   } else {
        logOut();
   }
    
   return request;
 }
 
 //Direct logOut method just incase needed
void Login::logOut() {
    VFP.authorize(false);
}
