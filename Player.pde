/*
  Player - a person controlled by keypresses

  Brian Vullo
*/
class Player extends Person {
  int jumpsLeft; // number of jumps we currently have left 
  int PLAYER_SPEED = 3; // the speed of the player
  int JUMPS_AVAILABLE = 2; // the max jumps available to the player
  int JUMP_HEIGHT = 5; // the height of 
  
  Player(Integer x, Integer y, String imageLocation, int w, int h, int health, String projectileImageLocation) {
    super(x, y, imageLocation, w, h, health, projectileImageLocation);
    jumpsLeft = JUMPS_AVAILABLE;
    this.subscribeToKeyPress();
    this.setScore(0);
  }
  
  Player(Integer x, Integer y, String imageLocation, int health, String projectileImageLocation) {
    super(x, y, imageLocation, health, projectileImageLocation);    
    jumpsLeft = JUMPS_AVAILABLE;
    this.subscribeToKeyPress();
    this.setScore(0);
  }
  
  
  void dispatchAction(String action) { //<>//
    switch(action) {
     case "move left": // move left action
       if(vel.x > -PLAYER_SPEED) { // if we havent hit the max player speed
         this.setDirectionLeft(); // set the firection to left
         this.vel.add(new PVector(-1, 0)); // increment the velocity in the x to the left 
       }
       break;
     case "move right": // move right action
       if(vel.x < PLAYER_SPEED) {
         this.setDirectionRight();
         this.vel.add(new PVector(1, 0));
       }  
       break;
     case "jump": // jump action
       if(vel.y > -PLAYER_SPEED && jumpsLeft > 0) { // if we have jumps left
         jumpsLeft--;
         this.vel.add(new PVector(0, -JUMP_HEIGHT)); // add the jump height to the velocity
         this.enableGravity(); // make sure gravity is enabled
       }
       break;
     case "down": // down action
       if(vel.y < PLAYER_SPEED) { 
          this.vel.add(new PVector(0, 1));
       }
       break;
     case "fire": // fire action
       this.fire();
       break;
     default:
       println("unrecognized keypress");
    }
  }
  
  // gets the score of the current player
  float getScore() {
     return this.attributes.get("score"); 
  }
  
  // sets the score of the current player
  void setScore(float val) {
     this.attributes.put("score", val);
  }
  
  // are we alive?
  Boolean isAlive() {
     return this.getHealth() > 0;
  }

  // on bottom collision, reset our jumps available
  @Override
  void bottomCollisionHook() {
    super.bottomCollisionHook();
    this.jumpsLeft = JUMPS_AVAILABLE;
  }
  
}
