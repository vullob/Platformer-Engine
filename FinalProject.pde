/*
  Platformer Engine - a simple platformer engine which uses properly formed JSON game files.  Load a properly formed game file to begin.
  
  See the template.json file for information on how to create a game file.

  Brian Vullo
*/

World theWorld; // The instance of the game engine's world
InputController inputController = new InputController();  // The controller for input
FileParser parser = new FileParser(); // The file parser
Menu menu = new Menu(); // The menu object
GameOverScreen gameOverScreen = new GameOverScreen(); // The Game Over screen objecct
String selectedFile; // The game file location 
Integer state = 0; // the current game state

// The current x val of the screen center - referenced as a global variable
Integer CURRENT_SCREEN_CENTER = 0;

void setup() {
  size(1280, 720); // render the application
}

// function which loads the passed file name, renders a menu error if an exception is thrown
void loadFile(String fileName) {
  try {
    menu.error = false;
    theWorld = parser.loadFile(fileName, inputController);
  } catch (Exception e) {
     menu.error(); 
  }
}

void draw() {
  switch(state) {
    case 0: // menu state
      menu.render();
      break;
    case 1: // game state
      // check the heartbeat of the world to see if we're in the game over state yet
      if(!theWorld.gameOver) {
        theWorld.render();
      } else {
        state++;
      }
      break;
   case 2: // game over screen
     gameOverScreen.render();
     break;
   case 3: // reset state
     this.loadFile(selectedFile);
     this.state = 1;
     break;
   default:
     println("something went horribly wrong");
  }
}

void mousePressed() {
  switch(state) {
     case 0: // if we're in the menu, delegate to the menu object
        menu.handleMousePress();
        break;
     case 2: // if we're in the game over screen, delegate to that
        gameOverScreen.handleMousePress();
     default:
       println("mouse press not recognized");
  }
}

// callback to handle file selection
void fileSelected(File selection) {
  if (selection == null) {
    menu.error();
    println("Window was closed or user hit cancel.");
  } else {
    // load the selected file
    selectedFile = selection.getAbsolutePath();
    loadFile(selection.getAbsolutePath());
    if(!menu.error) { // if we don't error on loading, load the world
      state++;
    }
  }
}

void keyPressed() {
  if(state == 1) {
    if(key == 'r') { // re-load the world if we press r
        this.loadFile(selectedFile);
    } else { // otherwise, delegate to the input controller
      inputController.handleKeyPress();
    }
  }
}

// on key release, delegate to the inputcontroller
void keyReleased() {
  inputController.handleKeyReleased();
}
