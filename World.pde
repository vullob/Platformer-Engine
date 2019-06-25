/*
  World - the container for all objects

  Brian Vullo
*/
class World {
 ArrayList<Object> objects; // the list of objects in the world
 CollisionEngine collisionEngine; // the collisionEngine for the world
 Player player; //the player
 InputController inputController; // input controller reference
 Camera camera; // the camera for the world
 Boolean gameOver = false; // is the game over yet?
 Boolean gameWon = false; // did we win?
 Timer timer = new Timer(); // the timer for the world
 int br, bg, bb; // background rgb values
 Boolean lazyLoad = true; // can we lazyload objects in this world?
 
 World(int br, int bg, int bb, Player p, InputController inputController) {
   this.br = br;
   this.bg = bg;
   this.bb = bb;
   this.objects = new ArrayList();
   this.inputController = inputController;
   this.player = p;
   objects.add(player);
   this.collisionEngine = new CollisionEngine(objects);
   this.camera = new Camera(objects);
 }
 
 // renders the score, health, and timer
 void renderHUD() {
    fill(255, 255, 255);
    textAlign(LEFT, TOP);
    textSize(20);
    text("Health: " + player.getHealth(), 10, 10);
    text("Score: " + player.getScore(), 10, 35);
    textAlign(RIGHT, TOP);
    text("Time: " + timer.getCurrentTime(), width - 10, 10);
 }
   
 void render() {
   ArrayList<Object> objectsToRender = camera.getObjectsInScene(player.loc.x); // get the objects currently in the scene
   ArrayList<Object> objectsToTick = lazyLoad ? objectsToRender : objects; // if we lazyload, only tick objects in the scene
   background(br, bg, bb); // render the background
   this.tick();
   pushMatrix(); // shift the x axis along the camera offset
   translate(-camera.getOffset(), 0);
   for(Object o : objectsToTick) { // tick all the objects that need to be ticked
     o.tick(collisionEngine);     
   }
   for(Object o: objectsToRender) { // render all the objects that need to be rendered
     o.render();  
   }
   popMatrix();
   renderHUD(); // render the HUD last so it's on top
 }
 
 void tick() {
    if(!player.isAlive()) this.gameOver(); // check the player's heartbeat
    ArrayList<Object> subscribedObjects = new ArrayList(); // get the objects subscribed to key presses
    for(Object o: objects) {
      if(o.subscribedToKeyPress) {
        if(o.exclusiveKeyPress) { // if an object has exclusive key presses
          subscribedObjects.clear(); // clear the other objects
          subscribedObjects.add(o); // add our object
          break; // break out of the loop
        }
        subscribedObjects.add(o); // otherwise, add the object to the list of subscribed objects
      }
    }
    for(Object o : subscribedObjects) { // for each object
        for(Integer i: inputController.getKeysReleased()) { // trigger the keys released
           o.handleKeyReleased(i); 
        }
        for(Integer i: inputController.getActiveKeys()) { // trigger the keys pressed
           o.handleKeyPress(i);
        } 
    }
 }
 
 // toggles lazy loading to the lazyload value
 void setLazyLoad(Boolean lazyLoad) {
    this.lazyLoad = lazyLoad; 
 }
 
 // sets the game to being over
 void gameOver() {
    this.timer.stopTimer();
    this.gameOver = true;
 }
 
 // gets the current score of the player
 float getScore() {
    return this.player.getScore();
 }
 
 // gets the time of the world
 String getTime() {
   return this.timer.getCurrentTime(); 
 }
 
 // wins the game
 void gameWon() {
    this.gameOver();
    this.gameWon = true;
 }
 
 // adds an object to the world
 void addObject(Object o) {
  objects.add(o); 
 }
 
 // adds a list of objects to the world
 void addAllObjects(ArrayList<Object> objects) {
   for(Object o : objects) {
      this.objects.add(o); 
   }
 }
 
  
}
