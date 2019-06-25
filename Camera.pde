/*
  Camera - responsible  for calculating shifts along the x axis, to scroll the platformer

  Brian Vullo
*/
class Camera {
   ArrayList<Object> objects; // the objects in the world
   Integer xOffset = 0; // the current offset
   Integer MIN_X_OFFSET = width/2; // the minimum x offset allowed
   
   Camera(ArrayList<Object> objects) {
      this.objects = objects;
   }
   
   // centers the camera around the passed x coordinate
   void centerCamera(Integer playerX){
     // get the difference in the offset, and adjust the xOffset accordingly
     Integer offsetDiff = (Integer) playerX - MIN_X_OFFSET;
     if(offsetDiff > 0) {
           xOffset = offsetDiff;
     } else if (playerX < MIN_X_OFFSET){
        xOffset = 0; 
     }
     // update the current screen center
     CURRENT_SCREEN_CENTER = xOffset + width/2;
   }
   
   // get the current offset
   float getOffset() {
     return xOffset; 
   }
   
   // get the current objects in the scene
   ArrayList<Object> getObjectsInScene(float playerX) {
     centerCamera((Integer) Math.round(playerX));
     ArrayList<Object> out = new ArrayList();
     // check to see if the object is in the scene, or not lazy loaded
     for(Object o : objects) {
      if(!o.lazyLoad || abs(o.loc.x - xOffset) <= width) {
         out.add(o);
       }
     }
     return out;
   }
  
  
}
