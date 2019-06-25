/*
  InputController - controls which key events should be sent on each tick 

  Brian Vullo
*/
class InputController { 
  ArrayList<Integer> keysPressed; // the keys that are currently pressed
  ArrayList<Integer> keysReleased; // the keys that have just been released
  
  InputController() {
     this.keysPressed = new ArrayList();
     this.keysReleased = new ArrayList();
  }
 
  // on key press, if we haven't already added it to the keysPressed array, then add it
  void handleKeyPress() { 
   if(!keysPressed.contains(keyCode)){
      keysPressed.add(keyCode);
    }
  }
  
  // gets the keys that are currently pressed
  ArrayList<Integer> getActiveKeys() {
      return keysPressed;
  }
  
  // gets the keys that should be released, and clears the cache
  ArrayList<Integer> getKeysReleased() {
     ArrayList<Integer> out = new ArrayList();
     for(Integer i : keysReleased) {
        out.add(i); 
     }
     keysReleased.removeAll(out);
     return out;
  }
 
 
  // on a key release, we remove it from the keysPressed, and add it to the keysReleased
  void handleKeyReleased() {
   if(keysPressed.contains(keyCode)){
     keysPressed.remove((java.lang.Object) keyCode); // must be case to an object to avoid removing based on index
     keysReleased.add(keyCode);
   }
   
 }
  
  
}
