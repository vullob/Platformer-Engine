/*
  Menu - the main load file menu

  Brian Vullo
*/
class Menu {
  Boolean error = false; // has an error been thrown?
  
  void render() {
    background(85,180,255);
    textSize(30);
    textAlign(CENTER);
    rectMode(CENTER);
    fill(255, 255, 255);
    text("Welcome To Platformer Engine!", width/2, height/8); // renders welcome text
    if(checkMenuButtonCollision(mouseX, mouseY)) { // if we've collided with the menu button, choose a darker fill
      fill(43, 50, 62);
    } else {
      fill(105, 121, 147);
    }
    rect(width/2, height/2, width/2, height/4);
    fill(255, 255, 255);
    text("Click To Load Game File", width/2, height/2); // render button text
    
    if(error) { // if an error occurred, render error text
       fill(255, 0, 0);
       text("An Error Occurred loading game file, please verify the fields and try again", width/2, height/8*6); 
    }
  }
  
  // checks if we've collided with the load file button
  boolean checkMenuButtonCollision(Integer x, Integer y) {
     return x > width/4 && x < width/4 * 3 && y > height/8 * 3 && y < height/8 * 5;
  }
  
  // toggles the error field
  void error() {
     this.error = true; 
  }
  
  // mouse handler, shows load file dialogue if mouse is within button
  void handleMousePress() {
     if(checkMenuButtonCollision(mouseX, mouseY)){
       println("selecting file");
       selectInput("Select a game file to load", "fileSelected");
     }
  }  
}
