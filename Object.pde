/* //<>//
  Object - the base object class, all objects should extend from it

  Brian Vullo
*/
class Object {
  PVector loc; // the current location of the object
  PImage img; // the image to render for the object
  Integer objWidth, objHeight; // the rendered width/height
  HashMap<String, Float> attributes; // the attributes associated with the object and their values
  Boolean collision = true; // whether or not we can collide with other objects
  Boolean rendered = false; // should this object be rendered
  Boolean subscribedToKeyPress = false; // are we subscribed to keypress events
  Boolean exclusiveKeyPress = false; // should ve exclusively subscribe to keypress events
  Boolean lazyLoad = true; // can this object be lazyloaded?
  HashMap <Integer, KeyBinding> bindings; // the keybindings for this object
  
  Object(Integer x, Integer y) {
    this.bindings = new HashMap();
    this.loc = new PVector(x, y);
    attributes = new HashMap();
    this.objWidth = 0;
    this.objHeight = 0;
  }

  Object(Integer x, Integer y, String imageLocation) {
    this(x, y);
    this.img = loadImage(imageLocation);
    this.objWidth = img.width;
    this.objHeight = img.height;
    enableRendering();
  }

  Object(Integer x, Integer y, PImage image, Integer w, Integer h) {
    this(x, y);
    this.objWidth = w;
    this.objHeight = h;
    this.img = image;
    enableRendering();
  }

  Object(Integer x, Integer y, String imageLocation, Integer w, Integer h) {
    this(x, y, imageLocation);
    objWidth = w;
    objHeight = h;
    enableRendering();
  }
  
  // sets the width of the object
  void setWidth(Integer w) {
     this.objWidth = w; 
  }
  
  // sets the height of the object
  void setHeight(Integer h) {
     this.objHeight = h; 
  }
  
  // sets the image for the object
  void setImage(String imageLocation) {
     this.img = loadImage(imageLocation);
     this.objWidth = img.width;
     this.objHeight = img.height;
     this.enableRendering();
  }

  // disable collision for the object
  void disableCollision() {
    this.collision = false;
  }

  // enables collision for the object
  void enableCollision() {
    this.collision = true;
  }
  
  // enables rendering for the object
  void enableRendering() {
    this.rendered = true;
  }

  // adds a new key binding from the key to the binding action
  void addKeyBinding(Integer key, String binding, Boolean sticky) {
    KeyBinding keyBinding = new KeyBinding(sticky, binding);
    bindings.put(key, keyBinding);
  }

  // disables rendering
  void disableRendering() {
    this.rendered = false; 
  }
  
  // subscribes the object to key press events
  void subscribeToKeyPress() {
     this.subscribedToKeyPress = true; 
  }
  
  // unsubscribes the object from keypress events
  void unsubscribeFromKeyPress() {
     this.subscribedToKeyPress = false; 
  }
  
  // makes the keyPress events exclusive to the object
  void setExclusiveKeyPress() {
     this.exclusiveKeyPress = true; 
  }
  
  // removes the exlusive from the keypress events
  void removeExclusiveKeyPress() {
     this.exclusiveKeyPress = false; 
  }
  
  // applies an attribute modifier to the object if it has the attribute
  void applyModifier(String attribute, float effect) {
     if(attributes.containsKey(attribute)) {
        attributes.put(attribute, attributes.get(attribute) + effect); 
     }
  }
  
  // handles key presses if we have a binding for it
  void handleKeyPress(Integer code) {
     KeyBinding binding = bindings.getOrDefault(code, null);
     if(binding != null && (!binding.registered || binding.sticky)) { // only process it if we haven't already processed the keypress, or if it's sticky
       this.dispatchAction(binding.binding);
       binding.registerKeyProccessed();
     }
  }
  
  // handles key releases if we have a binding for it
  void handleKeyReleased(Integer code) {
    KeyBinding binding = bindings.getOrDefault(code, null);
    if(binding != null && binding.registered) {
      binding.registerKeyReleased();
    }
  }
  
  // sets the dimensions of the object
  void setDimensions(Integer w, Integer h){
     this.objWidth = w;
     this.objHeight = h;
  }
  
  // callback for keypress actions
  void dispatchAction(String _) {}
  
  // hook for when projectiles collide with the object
  void projectileCollisionHook(Projectile _) {}
  
  // hook for when objects ddddddcollide with the top of this object
  void topCollisionHook() {};
  
  // hook for when objects collide with the bottom of this object
  void bottomCollisionHook() {};
  
  // tick to update the state of this objects
  void tick(CollisionEngine _) {}

  // basic render implementation, can be overridden by inheriting classes
  void render() {
    if(rendered) { // only render if rendering is enabled
      imageMode(CENTER);
      if (objWidth != null && objHeight != null) { // if we have a height/width, use it
        image(img, loc.x, loc.y, objWidth, objHeight);
      } else { // otherwise, just render the image
        image(img, loc.x, loc.y);
      }
    }
  }
}
