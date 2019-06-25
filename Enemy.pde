/*
  Enemy - An enemy that moves in between boundaries and fires on a set interval

  Brian Vullo
*/
class Enemy extends Person {
  Integer leftBoundary, rightBoundary; // the x coordinates of the left and right boundaries
  Integer timeSinceFired; // the time since the last shot was fired
  Integer ENEMY_SPEED = 2; // the speed of the enemy
  Integer FIRE_RATE = 20; // frames in between each shot fired
  Boolean allowBounceAttack = true; // can the enemy be killed by bouncing on top of them
  
  Enemy(Integer x, Integer y, String imageLocation, int w, int h, int health, 
    String projectileImageLocation, Integer leftBoundary, Integer rightBoundary) {
    super(x, y, imageLocation, w, h, health, projectileImageLocation);
    this.leftBoundary = leftBoundary;
    this.rightBoundary = rightBoundary;
    this.timeSinceFired = FIRE_RATE;
  }

  @Override
  void tick(CollisionEngine collisionEngine) {
    super.tick(collisionEngine);
    this.move(); // move on each tick
    if (timeSinceFired >= FIRE_RATE) { // fire if appropriate amount of frames has passed
      timeSinceFired = 0;
      this.fire();
    } else {
      timeSinceFired++;
    }
  }

  @Override
  void topCollisionHook() {
    // die if someting bounces on us
    if (this.allowBounceAttack) {
      this.die();
    }
  }
  
  // disable bounce attacks
  void disableBounceAttack() {
   this.allowBounceAttack = false; 
  }

  // moves the enemt
  void move() {
    switch(this.getDirection()) {
      case "right": // we're moving right
        if (loc.x < rightBoundary) { // check if we've hit the boundary
          moveRight(); // if not, keep moving right
        } else { // otherwise, reset our velocity and begin moving left
          this.vel.x = 0;
          moveLeft();
        }
        break;
      case "left": // do the same for moving left
        if (loc.x > leftBoundary) moveLeft(); 
        else {
          this.vel.x = 0;
          moveRight();
        }
        break;
      default:
        println("something went horribly wrong");
    }
  }

  // moves the enemy left
  void moveLeft() {
    if (loc.x >= leftBoundary && abs(vel.x) < ENEMY_SPEED) {
      this.setDirectionLeft();
      this.vel.add(new PVector(-1, 0));
    }
  }

  // moves the enemy right
  void moveRight() {
    if (loc.x <= rightBoundary && abs(vel.x) < ENEMY_SPEED) {
      this.setDirectionRight();
      this.vel.add(new PVector(1, 0));
    }
  }
}
