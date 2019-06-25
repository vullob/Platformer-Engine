/*
  keyBinding - holds information relating keys to their actions

  Brian Vullo
*/
class KeyBinding { 
   Boolean sticky = false; // should this key stick?
   Boolean registered = false; // has this key been registered yet?
   String binding; // what's the action that this key is bound to?
   
   KeyBinding(Boolean sticky, String binding) {
      this.sticky = sticky;
      this.binding = binding;
   }
   
   // registes that a key has been processed
   void registerKeyProccessed() {
      this.registered = true; 
   }
  
   // registers that a key has been released
   void registerKeyReleased() {
      this.registered = false;
   }
  
}
