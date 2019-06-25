/*
  Projectile - a projectile attack  

  Brian Vullo
*/
class Projectile extends MoveableObject {
  int damage; // projectile damage
  int maxDistance; // max distance that the projectile can travel
  PVector startingLoc; // the location where the projectile was fired
  Boolean completed = false; // has this projectile been completed yet?
  
  Projectile(Integer x, Integer y,  PVector velocity, int damage, int maxDistance, PImage image) {
   super(x, y, velocity, image, image.width, image.height); 
   this.damage = damage;
   this.maxDistance = maxDistance;
   this.startingLoc = new PVector(x, y);
   this.disableGravity();
  }
  
  @Override
  void tick(CollisionEngine collisionEngine) {
    if(!completed) { // if we haven't been completed yet
        this.loc.x += this.vel.x; // add the velocity to the current location
        Object collidingObject = collisionEngine.getCollidingObject(this); // check to see if we have a colliding object - if we do, call it's collision hook
        if(collidingObject != null){
            collidingObject.projectileCollisionHook(this);
         }
        if(dist(loc.x, loc.y, startingLoc.x, startingLoc.y) >= maxDistance){ // if we've reached the max distance for the projectile, mark it as completed
          completed = true;
        }
      }
  }
}
