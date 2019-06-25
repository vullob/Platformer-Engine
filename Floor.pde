/*
  Floor - a static tile with collision

  Brian Vullo
*/
class Floor extends Object {
  
    Floor(Integer x, Integer y, PImage image, Integer w, Integer h) {
      super(x, y, image, w, h);
    }
    
    // if a projectile collides with us, it doesn't go anywhere else
    @Override
    void projectileCollisionHook(Projectile p) {
      p.completed = true;
    }
  
    void print() {  
        println("{\"x\": " + (int) this.loc.x + ",\"y\": " + (int) this.loc.y + "},"); 
    }
}
