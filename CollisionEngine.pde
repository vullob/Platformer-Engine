/*
  CollisionEngine - Service class  to calculate collisions with other objects

  Brian Vullo
*/
class CollisionEngine {
   ArrayList<Object> objects; // reference to the objects in the world
   
   CollisionEngine(ArrayList<Object> objects) {
      this.objects = objects; 
   }
   
   // check to see if the object is collising with any other objects
   Boolean checkCollision(Object o){
     if(!o.collision) return false;
     for(Object other : objects) {
       if(other != o && other.collision) {
         if(checkForObjectCollision(o, other, "Coordinate")) {
            return true; 
         }
       }
     }
     return false;
   }
   
   // check to see if A is colliding with B in the specified type of collision
   // Type is one of 'X', 'Y', or 'Coordinate';
   Boolean checkForObjectCollision(Object objectA, Object objectB, String type) {
     switch(type) {
        case "Coordinate": // a coordinate type is an exact match to see if the objects are colliding on both the X and Y axis
           if(objectA != objectB) {
             return checkForObjectCollision(objectA, objectB, "X") && checkForObjectCollision(objectA, objectB, "Y");
           }
           break;
        case "X": // checks if the object A has collided with the a vertical line at the X coordinate of objectB 
          if(objectA.loc.x - objectA.objWidth/2 - objectB.objWidth/2 < objectB.loc.x 
              && objectA.loc.x + objectA.objWidth/2 + objectB.objWidth/2 > objectB.loc.x) {
             return true; 
          }
          break;
        case "Y": // checks if the object A has collided with the a horizontal line at the Y coordinate of objectB
          if(objectA.loc.y - objectA.objHeight/2 - objectB.objHeight/2 < objectB.loc.y 
              && objectA.loc.y + objectA.objHeight/2 + objectB.objHeight/2 > objectB.loc.y) {
             return true; 
          }
          break;
       default:
         println("Invalid collision type");            
     }
    return false;
   }
  
  // gets to object that is currently colliding with o 
  Object getCollidingObject(Object o) {
     if(!o.collision) return null;
     for(Object other : objects) {
       if(other != o && other.collision) {
         if(checkForObjectCollision(o, other, "Coordinate")) {
             return other;
         }
       }
     }
     return null;
  }
}
