require('alerts.js')
require('alerts.css')

function Login(root, config) {
   var obj = this;


   this.showPopup = function (id) {
      if (!authorized) {
         jPrompt(config.loginPrompt, "", config.loginText, function (password) {
            if (password !== null && password.length !== 0) 
               postEvent(id, [1, password]);
            else
               setTimeout(checkLogin, 1000);  
         }, "password");
      } else {
         jConfirm(config.logoutPrompt, config.logoutText, function (logout) {
            if (logout) {
               jQuery('.outer').addClass('not-clickable');
               postEvent(id, 0);
            }
         });
      }         
   };   

   this.authError = function () {      
      jError(config.errorPrompt, config.loginText, checkLogin);
   };

   // If the login control is not part of the DOM, i.e. is not placed then we nned to
   // implement only the popup mechanism.
   var loginControl = document.getElementById(root.id);
   if (loginControl === 'undefined' || loginControl === null) {
      checkLogin();
      return this;
   }

   // Otherwise, if the login control is part of the DOM:
   var bounds = root.getElementsByClassName("bounds")[0];
   var lamp = root.getElementsByClassName("lamp")[0];
   var bbox = bounds.getBBox();
   var label = root.getElementsByTagName("text")[0];
   var plock = root.getElementsByClassName("padlock");
   var pressed = false;
   var state = 0;
   var symbols = root.getElementsByTagName("g");

   setHotSpot(this, root);

   // Fix legacy issues with inkscape:
   symbols[0].removeAttribute('display');
   symbols[1].removeAttribute('display');

   setLamp(0);


   this.reconfigure = function (newinstance) {
      if (newinstance) {
         config.labelFont = getFontStyle(label);
      }

      console.log(config.loginText)
      label.firstChild.nodeValue = config.loginText;
      l = label;
      console.log(label);
      label.style.pointerEvents = "none";
      setFontStyle(label, config.labelFont);

      var x = null, y = null;
      var h = label.getBBox().height * 0.6;
      var s = parseInt(config.labelSpacing);
      switch (parseInt(config.labelPosition)) {
         case 1:
            label.style.textAnchor = "middle";
            x = bbox.width / 2;
            y = -s;
            break;
         case 2:
            label.style.textAnchor = "middle";
            x = bbox.width / 2;
            y = bbox.height + s + h;
            break;
         case 3:
            label.style.textAnchor = "end";
            x = -s;
            y = bbox.height / 2 + h / 2;
            break;
         case 4:
            label.style.textAnchor = "start";
            x = bbox.width + s;
            y = bbox.height / 2 + h / 2;
            break;
      }

      if (x != null && y != null) {
         label.setAttribute('x', x);
         label.setAttribute('y', y);
         label.style.display = "inherit";
      } else {
         label.style.display = "none";
      }

      setLamp(state);
      display(false);
   };

   this.onmousedown = function (evt) {
      display(true);
      buttonClick();
      this.showPopup(obj.id);
   };

   this.onmouseup = function (evt) {
      display(false);
   };

   this.updateAuthorization = function (auth) {
   // Update the logic state
      if (state != auth) {  
         state = auth;
         label.firstChild.nodeValue = state ? config.logoutText : config.loginText;
         setLamp(state ? 1 : 0);
         display(pressed);
      }         
   }

   function setLamp (state) {
      switch (state) {
         case 0:
            lamp.style.fill = config.lampColour;
            lamp.style.opacity = 0.2;
            break;
         case 1:
            lamp.style.fill = config.lampColour;
            lamp.style.opacity = 1.0;
            break;
      }
   };

   function display(down) {
      plock[0].style.display = 'none';
      plock[1].style.display = 'none';
      plock[2].style.display = 'none';
      plock[3].style.display = 'none';

      if (down) {
         symbols[0].style.display = 'none';
         symbols[1].style.display = 'inline';
         if (state == 1) {
            plock[3].style.display = 'inline';
         } else {
            plock[1].style.display = 'inline';
         }
      } else {
         symbols[0].style.display = 'inline';
         symbols[1].style.display = 'none';
         if (state == 1) {
            plock[2].style.display = 'inline';
         } else {
            plock[0].style.display = 'inline';
         }
      }
      pressed = down;
   };

 
   return this;
}