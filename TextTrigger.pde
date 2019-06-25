/*
  TextTrigger - a trigger to display text to the user

  Brian Vullo
*/
class TextTrigger extends Trigger {
  String dissmissText = "PRESS ENTER TO CONTINUE"; // text to dismiss the message
  String text; // the text to display
  Integer br, bb, bg, ba; // background rgb and alpha values
  Integer tr, tb, tg; // text rgb and alpha values

  TextTrigger(Object triggerObject, Integer pos, String type, String text) {
    super(triggerObject, pos, type);
    this.init(text);  
  }

  TextTrigger(Object triggerObject, Integer xPos, Integer yPos, String text) {
    super(triggerObject, xPos, yPos);
    this.init(text);
  }

  TextTrigger(Object triggerObject, Integer xPos, Integer yPos, String imageLocation, Integer w, Integer h, String text) {
    super(triggerObject, xPos, yPos, imageLocation, w, h);
    this.init(text);  
  }

  TextTrigger(Object triggerObject, Integer xPos, Integer yPos, PImage image, Integer w, Integer h, String text) {
    super(triggerObject, xPos, yPos, image, w, h);
    this.init(text);
  }
  
  void init(String text) {
     this.text = text;
     this.addKeyBinding(10, "dismiss", false); // defaults to enter key - perhaps should be customizable?
     br = 0;
     bb = 0;
     bg = 0;
     ba = 128;
     tr = 255;
     tb = 255;
     tg = 255;
  }

  // set the text to be displayed
  void setText(String text) {
    this.text = text;
  }

  @Override
  void triggerEvent() {
     super.triggerEvent();
     this.subscribeToKeyPress(); // subscribe to keypresses on trigger
  }
  
  @Override
  void unTriggeredEvent(){
    super.unTriggeredEvent();
    this.sticky = false; // on untrigger, we turn off stickyness
  }
  
  
  @Override
  void dispatchAction(String action) {
    switch(action) {
       case "dismiss":
         this.unTriggeredEvent(); //  on dismiss, disable stickyness
         this.unsubscribeFromKeyPress(); // and unsubscribe from the keypress events
         break;
       default:
         println("something went horribly wrong");
    }
  }

  @Override
  void render() {
    super.render();
    if (this.triggered) { // if we're been triggered
      rectMode(CENTER);
      textAlign(CENTER);
      fill(br, bb, bg, ba);   // draw the rect to display the text on
      rect(CURRENT_SCREEN_CENTER, height/8, width + width/8, height/8 * 2);
      fill(tr, tb, tg); // write the text in the center of the screen
      text(text, CURRENT_SCREEN_CENTER, height/8);
      if(this.sticky) { // if we're still sticking, display the dismiss text
        text(dissmissText, CURRENT_SCREEN_CENTER + width/8 * 2, height/16 * 3);
      }
    }
  }
}
