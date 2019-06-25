/*
  MoveableObject - the base class for an object which has a velocity 

  Brian Vullo
*/
class MoveableObject extends Object {
  PVector vel; // the velocity
  PVector gravity = new PVector(0, 0.1); // gravity to be applied
  PVector friction = new PVector(0.05, 0); // friction to be applied 
  Boolean gravityEnabled = true; // wheter or not gravity is enabled for the object
  
  MoveableObject(Integer x, Integer y, PVector velocity, String imageLocation) {
    super(x, y, imageLocation);
    this.vel = velocity;
  }
  
  MoveableObject(Integer x, Integer y, PVector velocity, PImage image, Integer w, Integer h) {
    super(x, y, image, w, h);
    this.vel = velocity;
  }
  
  MoveableObject(Integer x, Integer y, PVector velocity, String imageLocation, Integer w, Integer h) {
    super(x, y, loadImage(imageLocation), w, h);
    this.vel = velocity;
  }
  
  MoveableObject(Integer x, Integer y, String imageLocation, Integer w, Integer h) {
    this(x, y, new PVector(0,0), loadImage(imageLocation), w, h);
  }
  
  MoveableObject(Integer x, Integer y, String imageLocation) {
    super(x, y, imageLocation);
    this.vel = new PVector(0, 0);
  }
  
  // hook which is triggered when an object collided with the bottom of the object
  @Override
  void bottomCollisionHook() {
    this.vel.y = 0;
  }
  
  @Override
  void tick(CollisionEngine collisionEngine) {
    // add gravity to the velocity if it's enabled
    if (gravityEnabled) {
      vel.add(gravity);
    }
    // add the current velocity in the x
    this.loc.x += this.vel.x;
    // check if we've collided
    if(collisionEngine.checkCollision(this)){
      this.loc.x -= this.vel.x;  // if we have, move back to avoid the collision
    }
    // add the velocity in the y
    this.loc.y += this.vel.y;
    // check to see if we've collided
    if(collisionEngine.checkCollision(this)){
      // check to see if we've collided
      float temp = this.vel.y;
      if(this.vel.y > 0) { // if we have, and we're moving downward
         this.bottomCollisionHook(); // call our bottom collision hook
         collisionEngine.getCollidingObject(this).topCollisionHook(); // and their top collision hook
      }
      this.loc.y -= temp; // adjust to avoid collision
    }
    
    if (abs(this.vel.x) <= this.friction.x) { // set friction to 0 if we're near stopping
      this.vel.x = 0;
    } else if (this.vel.x > 0) { // if we're moving to the right, subtract the friction
      this.vel.sub(this.friction);
    } else if (this.vel.x < 0) { // if we're moing to the left, add the friction
      this.vel.add(this.friction);
    }
  }
  
  // enables gravity
  void enableGravity() {
    this.gravityEnabled = true;
  }

  // disables gravity
  void disableGravity() {
    this.gravityEnabled = false;
  }

  // sets the friction value
  void setFriction(float f) {
    this.friction = new PVector(f, 0);
  }

  // sets the gravity value
  void setGravity(float g) {
    this.gravity = new PVector(0, g);
  }
  

}
