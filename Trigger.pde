/*
  Trigger - an event which fires when the player reaches a certain xPos, yPos, or coordinate

  Brian Vullo
*/
class Trigger extends Object {
  String type; // the type of trigger - X, Y, or Coordinate
  Boolean triggered = false; // have we been triggered yet?
  Boolean sticky = true; // should we stay triggered after we've passed the trigger?
  Object triggerObject; // which object can trigger us
  
  Trigger(Object triggerObject, Integer pos, String type) {
    super(pos, pos);
    this.triggerObject = triggerObject;
    this.type = type; // one of X or Y
    this.init();
  }
  
  Trigger(Object triggerObject, Integer xPos, Integer yPos) {
    super(xPos, yPos);
    this.triggerObject = triggerObject;
    this.type = "Coordinate";
    this.init();
  }
  
  Trigger(Object triggerObject, Integer xPos, Integer yPos, String imageLocation, Integer w, Integer h) {
    super(xPos, yPos, imageLocation, w, h);
    this.triggerObject = triggerObject;
    this.type = "Coordinate";
    this.init();
  }
  
  Trigger(Object triggerObject, Integer xPos, Integer yPos, PImage image, Integer w, Integer h) {
    super(xPos, yPos, image, w, h);
    this.triggerObject = triggerObject;
    this.type = "Coordinate";
    this.init();
  }  
  
  // disable collisions, and make sure we don't lazy load triggers
  void init() {
    this.disableCollision();
    this.lazyLoad = false;
  }
  
  @Override
  void tick(CollisionEngine e) {
    if(e.checkForObjectCollision(triggerObject, this, type)) { // if we've collided with the trigger object
       this.triggerEvent(); // fire our trigger event
    } else if (!sticky) { // otherwise, if we aren't still sticking
       this.unTriggeredEvent();  // call the untrigger event
    }
  }
  
  // make the trigger sticky
  void setSticky() {
     this.sticky = true; 
  }
  
  // disable the stickyness of the trigger
  void disableSticky() {
     this.triggered = false;
     this.sticky = false; 
  }
  
  // on trigger, set the triggered boolean to true
  void triggerEvent(){ 
    this.triggered = true;
  }
  
  // on untrigger, set triggered to false
  void unTriggeredEvent() {
    this.removeExclusiveKeyPress();
    this.triggered = false;
  }
  
  
  
}
