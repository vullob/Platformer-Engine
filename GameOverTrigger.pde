/*
  GameOverTrigger - a trigger which ends the game, can either win the game, or end it in death

  Brian Vullo
*/
class GameOverTrigger extends Trigger {
  World theWorld; // the instance of the world
  Boolean winOnTrigger = false; // does this trigger win the game?
  
  GameOverTrigger(Object triggerObject, Integer pos, String type, World theWorld) {
    super(triggerObject, pos, type);
    this.theWorld = theWorld;
  }
  
  GameOverTrigger(Object triggerObject, Integer xPos, Integer yPos, World theWorld) { 
    super(triggerObject, xPos, yPos);
    this.theWorld = theWorld;
  }
  
  GameOverTrigger(Object triggerObject, Integer xPos, Integer yPos, String imageLocation, Integer w, Integer h, World theWorld) {
    super(triggerObject, xPos, yPos, imageLocation, w, h);
    this.theWorld = theWorld;
  }
  
  GameOverTrigger(Object triggerObject, Integer xPos, Integer yPos, PImage image, Integer w, Integer h, World theWorld){
    super(triggerObject, xPos, yPos, image, w, h);
    this.theWorld = theWorld;
  }
  
  void setWonTrigger(Boolean val) {
     this.winOnTrigger = val; 
  }

  
  @Override
  void triggerEvent() {
     super.triggerEvent(); // call out super method to signify that we've been triggered
     if(this.winOnTrigger) {
        this.theWorld.gameWon(); // if we're the win trigger, win 
     } else {
       this.theWorld.gameOver(); // otherwise, just end the game
     }
  }
  
}
