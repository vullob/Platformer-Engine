/*
  ModifierTrigger - A trigger which modifies the attributes of an object

  Brian Vullo
*/
class ModifierTrigger extends Trigger { 
    String attribute; // the attribute to modify
    float effect; // the effect to apply
  
    ModifierTrigger(Object triggerObject, Integer xPos, Integer yPos, String imageLocation, Integer w, Integer h, String attribute, float effect) {
      super(triggerObject, xPos, yPos, imageLocation, w, h);
      init(attribute, effect);
    }
  
    ModifierTrigger(Object triggerObject, Integer xPos, Integer yPos, PImage image, Integer w, Integer h, String attribute, float effect) {
       super(triggerObject, xPos, yPos, image, w, h);
       init(attribute, effect);
    }  
  
    void init(String attr, float effect) {
        this.attribute = attr;
        this.effect = effect;
    }
    
    // render the image if we havent yet been triggered
    @Override
    void render() {
       if(!this.triggered) {
           super.render(); 
       }
    }
    
    // apply the modifier if this is the first time we've been triggered 
    @Override
    void triggerEvent() {
      if(!triggered) {
         triggerObject.applyModifier(attribute, effect);
         super.triggerEvent();
      }       
    }
  
}
