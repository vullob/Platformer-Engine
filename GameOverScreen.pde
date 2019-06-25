/*
  GameOverScreen - The Game over screen

  Brian Vullo
*/
class GameOverScreen { 
  
  void render() {
    background(85,180,255);
    textSize(30);
    rectMode(CENTER);
    textAlign(CENTER);
    fill(255, 255, 255);
    text("GAME OVER", width/2, height/8); // render game over text
    
    // render text to say if you won/lost
    if(theWorld.gameWon) {
      fill(255, 255, 20);
      text("You Won!", width/2, height/8 * 3);
    } else {    
      fill(255, 0, 0);
      text("You Lost :(", width/2, height/8 * 3);
    }
    
    // render final player attributes
    text("Final Score: " + theWorld.getScore(), width/2, height/8 * 4);
    text("Time: " + theWorld.getTime(), width/2, height/16 * 9);
    
    // render buttons to play again/return to main menu
    if(checkForRectCollision(mouseX, mouseY, width/4, height/8*6)) {
       fill(43, 50, 62);
    } else {
       fill(105, 121, 147); 
    }
    rect(width/4, height/8 * 6, width/4, height/8);
    if(checkForRectCollision(mouseX, mouseY, width/4 * 3, height/8*6)) {
       fill(43, 50, 62);
    } else {
       fill(105, 121, 147); 
    }
    rect(width/4 * 3, height/8 * 6, width/4, height/8);
    textSize(20);
    fill(255, 255, 255);
    text("Play Level Again", width/4, height/8 * 6);
    text("Return to load level screen", width/4 * 3, height/8 * 6);
  }
   
  // checks if the my, my position is within the a a button at rectX,rectY 
  Boolean checkForRectCollision(Integer mX, Integer mY, Integer rectX, Integer rectY) {
     return mX > rectX - width/8 && mX < rectX + width/8 && mY > rectY - height/16 && mY < rectY + height/16; 
  }
  
  // mouse handler
  void handleMousePress() {
     if(checkForRectCollision(mouseX, mouseY, width/4, height/8*6)){
        state = 3; // if we're in the play again button, re-load the level
     } else if (checkForRectCollision(mouseX, mouseY, width/4 * 3, height/8*6)) { 
       state = 0; // if we're in the main menu button, return to the main menu.
     }
  }
}
