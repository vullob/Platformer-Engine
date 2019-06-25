/*
  Person - a moveable object with health and projectiles

  Brian Vullo
*/
class Person extends MoveableObject {
  ArrayList<Projectile> projectiles; // the projectiles belonging to this person
  int direction = 0; // the current direction of the Person 0 = right, 1 = left 
  PImage projectileImage; // the image of the person's projectiles
  Integer projectileDamage = 10; // the damage done by a person
  
  int MAX_PROJECTILE_DISTANCE = 300; // the distance that this person's projectiles can travle
  int PROJECTILE_VELOCITY = 10; // the velocity that this person's projectiles travel at
  
  Person(Integer x, Integer y, String imageLocation, int w, int h, int health, String projectileImageLocation) {
   super(x, y, imageLocation, w, h); 
   this.setHealth((float) health);
   this.projectiles = new ArrayList();
   this.projectileImage = loadImage(projectileImageLocation);
  }
  
  Person(Integer x, Integer y, String imageLocation, int health, String projectileImageLocation) {
   super(x, y, imageLocation); 
   this.setHealth((float) health);
   this.projectiles = new ArrayList();
   this.projectileImage = loadImage(projectileImageLocation);
  }
  
  // sets the direction of this person to the left
  void setDirectionLeft() {
     this.direction = 1; 
  }
  
  // reverses the direction of this person
  void reverseDirection() {
     this.direction = this.direction == 0 ? 1 : 0;
  }
  
  // sets the firection of this person to the right
  void setDirectionRight() {
     this.direction = 0; 
  }
  
  @Override
  void projectileCollisionHook(Projectile p) {
    if(!projectiles.contains(p)) { // if it's not one of our projectiles
       p.completed = true; // register the projectile as having hit
       this.setHealth(this.getHealth() - p.damage); // reduce this person's health by the correct amount
       if(this.getHealth() <= 0) { // if we're dead, then die
         this.die();
       }
    }
  }

  // sets the projectile damage
  void setProjectileDamage(Integer damage) {
     this.projectileDamage = damage;
  }
  
  // gets the health of this person
  float getHealth() {
     return this.attributes.get("health"); 
  }
  
  // sets the health of this person
  void setHealth(float val) {
     this.attributes.put("health", val); 
  }

  // kills this person
  void die() {
    this.setHealth(0); 
    disableGravity();
    disableCollision();
    disableRendering();
    projectiles.clear();
  }
  
  // gets the current direction of this person as a string 
  String getDirection() {
     return this.direction == 0 ? "right" : "left"; 
  }
  
  // fires a projectile in the current direction
  void fire() {
   Projectile p;
   switch(getDirection()){
      case "right": 
        p = new Projectile((int) loc.x, (int) loc.y, new PVector(PROJECTILE_VELOCITY,0), projectileDamage, 250, projectileImage);
        projectiles.add(p);
        break;
      case "left":
        p = new Projectile((int) loc.x, (int) loc.y, new PVector(-PROJECTILE_VELOCITY,0), projectileDamage, 250, projectileImage);
        projectiles.add(p);
        break;
      default: 
        println("NOT YET IMPLEMENTED");
   }
  }
  
  @Override
  void render() {
    if(rendered) {
      if(this.getDirection() == "left") { // if we're moving left, flip the image
         pushMatrix();
         scale(-1, 1);
         image(img, -loc.x, loc.y, objWidth, objHeight);
         popMatrix();  
      } else {
        super.render(); // otherwise, just render normally
      }
      for(Projectile p: projectiles) { // render our projectiles
         p.render(); 
      }
    }
  }
  
  @Override
  void tick(CollisionEngine collisionEngine) {
    if(this.getHealth() > 0) { // if we aren't dead
     super.tick(collisionEngine);
     ArrayList<Projectile> projectilesToRemove = new ArrayList(); // check if we have any projectiles to clean up
     for(Projectile p: projectiles) {
        p.tick(collisionEngine);
        if(p.completed) projectilesToRemove.add(p);
     }
     projectiles.removeAll(projectilesToRemove);
    }
  }
  
  // add a projectile to this person
  void addProjectile(Projectile p) {
    projectiles.add(p);
  }
 
    
}
