/*
  FileParser - parses properly formed JSON files into Worlds with the appropriate objects in them

  Brian Vullo
*/
class FileParser {
  JSONObject jsonRootObject; // the root json object for the game file
  
  // loads json from file and parses into a world
  World loadFile(String fileName, InputController inputController) {
     jsonRootObject = loadJSONObject(fileName); 
     return this.loadWorld(inputController);
  }
  
  // parses a comma seperated string of numbers into an array of integers
  private Integer[] parseCommaSeperatedString(String s) {
    String[] splitString = s.split(",");
    Integer[] out = new Integer[splitString.length];
    for(int i = 0; i < splitString.length; i++) {
      try{
        out[i] = Integer.parseInt(splitString[i]);
      } catch(Error e) {
        throw(new Error("Issue parsing comma seperated value")); 
      }
    }
    return out;
  }
  
 // parses a properly formatted player json object into 
 Player parsePlayerJSON() {
      Player out;
      JSONObject playerJSON = jsonRootObject.getJSONObject("player");
      if(playerJSON.hasKey("startingPosition") 
          && playerJSON.hasKey("imageLocation") 
          && playerJSON.hasKey("projectileImageLocation")
          && playerJSON.hasKey("health")) {
        String startingPosString = playerJSON.getString("startingPosition");
        String playerImageLocation = playerJSON.getString("imageLocation");
        String projectileImageLocation = playerJSON.getString("projectileImageLocation");
        Integer health = playerJSON.getInt("health");
        Integer[] positions = parseCommaSeperatedString(startingPosString);
        out = new Player(positions[0], positions[1], playerImageLocation, health, projectileImageLocation);
        if(playerJSON.hasKey("width") && playerJSON.hasKey("height")) {
           out.setWidth(playerJSON.getInt("width"));
           out.setHeight(playerJSON.getInt("height"));
        }        
        if(playerJSON.hasKey("projectileDamage")) {
           out.setProjectileDamage(playerJSON.getInt("projectileDamage")); 
        }
        
        if(playerJSON.hasKey("keyBindings")) {
          JSONArray keyBindingsJSON = playerJSON.getJSONArray("keyBindings");
          for(Integer i = 0; i < keyBindingsJSON.size(); i++) {
            JSONObject keyBinding = keyBindingsJSON.getJSONObject(i);
            out.addKeyBinding(keyBinding.getInt("keyCode"), keyBinding.getString("action"), keyBinding.getBoolean("sticky"));
          }
        } else {
           out.addKeyBinding(65, "move left", true);
           out.addKeyBinding(68, "move right", true);
           out.addKeyBinding(32, "jump", false);
           out.addKeyBinding(69, "fire", false);
           out.addKeyBinding(83, "down", true); 
        }
        
      } else {
         throw(new Error("Missing Player JSON fields")); 
      }
      return out;
  }
  
  //Parses a world with the specified properties
  private World parseWorldJSON(Player p, InputController inputController) {
      World out;
      JSONObject worldJSON = jsonRootObject.getJSONObject("world"); //<>//
      if(worldJSON.hasKey("backgroundColor")) {
        Integer[] bgRGB = parseCommaSeperatedString(worldJSON.getString("backgroundColor"));
        out = new World(bgRGB[0], bgRGB[1], bgRGB[2], p, inputController);
      } else {
         throw(new Error("World missing background color")); 
      }
      
      Boolean lazyLoad = worldJSON.hasKey("lazyLoad") ? worldJSON.getBoolean("lazyLoad") : true;
      out.setLazyLoad(lazyLoad);
      return out;
  }
  
  // creates text trigger objects with the specified properies from the root JSON object
  ArrayList<Object> parseTextTriggersJSON(Player p) {
     ArrayList<Object> out = new ArrayList();
     JSONArray triggers = jsonRootObject.getJSONArray("textTriggers");
     for(int i = 0; i < triggers.size(); i++){
       JSONObject triggerJSON = triggers.getJSONObject(i);
       if(triggerJSON.hasKey("type") && triggerJSON.hasKey("text")) {
         String type = triggerJSON.getString("type");
         String text = triggerJSON.getString("text");
         Integer xPos = triggerJSON.hasKey("x") ? triggerJSON.getInt("x") : null;
         Integer yPos = triggerJSON.hasKey("y") ? triggerJSON.getInt("y") : null;
         Boolean exclusive = triggerJSON.hasKey("exclusive") ? triggerJSON.getBoolean("exclusive") : false;
         String imageLocation = triggerJSON.hasKey("imageLocation") ? triggerJSON.getString("imageLocation") : null;
         Integer w = triggerJSON.hasKey("width") ? triggerJSON.getInt("width") : null;
         Integer h = triggerJSON.hasKey("width") ? triggerJSON.getInt("height") : null;
         switch(type) {
            case "X":
              if(xPos != null) {
                TextTrigger trigger = new TextTrigger(p, xPos, type, text);
                if(exclusive) trigger.setExclusiveKeyPress();
                out.add(trigger);
              } else {
                 throw(new Error("missing x position for trigger")); 
              }
              break;
            case "Y":
              if(yPos != null) {
                TextTrigger trigger = new TextTrigger(p, yPos, type, text);
                if(exclusive) trigger.setExclusiveKeyPress();
                out.add(trigger);
              } else {
                throw(new Error("missing y position for trigger")); 
              }  
              break;
            case "coordinate":
              if(yPos != null && xPos != null) {
                TextTrigger trigger = new TextTrigger(p, xPos, yPos, text);
                if(exclusive) trigger.setExclusiveKeyPress();
                if(imageLocation != null) trigger.setImage(imageLocation);
                if(h != null && w != null) trigger.setDimensions(w, h);
                out.add(trigger);
              } else {
                throw(new Error("missing coordinate for trigger")); 
              }
              break;
            default:
              throw(new Error("unknown trigger type " + triggerJSON.getString("type")));
          }
       } else {
           throw(new Error("invalid trigger object")); 
         }
     }
     
     return out;
  }
  
  //  creates gameOverTriggers with the specified properties in the rootJSONObject
  ArrayList<Object> parseGameOverTriggersJSON(Player p, World world){
      ArrayList<Object> out = new ArrayList();
     JSONArray triggers = jsonRootObject.getJSONArray("gameOverTriggers");
     for(int i = 0; i < triggers.size(); i++){
       JSONObject triggerJSON = triggers.getJSONObject(i);
       if(triggerJSON.hasKey("type")) {
         String type = triggerJSON.getString("type");
         Integer xPos = triggerJSON.hasKey("x") ? triggerJSON.getInt("x") : null;
         Integer yPos = triggerJSON.hasKey("y") ? triggerJSON.getInt("y") : null;
         String imageLocation = triggerJSON.hasKey("imageLocation") ? triggerJSON.getString("imageLocation") : null;
         Integer w = triggerJSON.hasKey("width") ? triggerJSON.getInt("width") : null;
         Integer h = triggerJSON.hasKey("width") ? triggerJSON.getInt("height") : null;
         Boolean win = triggerJSON.hasKey("winOnTrigger") ? triggerJSON.getBoolean("winOnTrigger") : false;
         switch(type) { //<>//
            case "X":
              if(xPos != null) {
                GameOverTrigger trigger = new GameOverTrigger(p, xPos, type, world);
                trigger.setWonTrigger(win);
                out.add(trigger);
              } else {
                 throw(new Error("missing x position for trigger")); 
              }
              break;
            case "Y":
              if(yPos != null) {
                GameOverTrigger trigger = new GameOverTrigger(p, yPos, type, world);
                trigger.setWonTrigger(win);
                out.add(trigger);
              } else {
                throw(new Error("missing y position for trigger")); 
              }  
              break;
            case "coordinate":
              if(yPos != null && xPos != null) {
                GameOverTrigger trigger = new GameOverTrigger(p, xPos, yPos, world);
                if(imageLocation != null) trigger.setImage(imageLocation);
                if(h != null && w != null) trigger.setDimensions(w, h);
                trigger.setWonTrigger(win);
                out.add(trigger);
              } else {
                throw(new Error("missing coordinate for trigger")); 
              }
              break;
            default:
              throw(new Error("unknown trigger type " + triggerJSON.getString("type")));
          }
       } else {
           throw(new Error("invalid trigger object")); 
         }
     }
     return out;
  }
  
  // parses floor objects from the root JSON file
  ArrayList<Object> parseFloorJSON() {
    ArrayList<Object> out = new ArrayList();
    JSONArray floorListJSON = jsonRootObject.getJSONArray("tiles");
    for(int i = 0; i < floorListJSON.size(); i++) {
        JSONObject floorJSON = floorListJSON.getJSONObject(i);
        PImage floorImage;
        Integer h, w;
        if(floorJSON.hasKey("imageLocation") && floorJSON.hasKey("locations")){
          floorImage = loadImage(floorJSON.getString("imageLocation"));
          if(floorJSON.hasKey("height") && floorJSON.hasKey("width")) {
             h = floorJSON.getInt("height");
             w = floorJSON.getInt("width");
          } else {
             h = floorImage.height;
             w = floorImage.width;
          }
          JSONArray locations = floorJSON.getJSONArray("locations");
          for(int j = 0; j < locations.size(); j++){
            JSONObject floorLocation = locations.getJSONObject(j);
            if(floorLocation.hasKey("x") && floorLocation.hasKey("y")) {
               out.add(new Floor(floorLocation.getInt("x"), floorLocation.getInt("y"), floorImage, w, h)); 
            } else {
               throw(new Error("missing coordinate in tile location")); 
            }
          }
        } else {
           throw(new Error("Missing required Tile fields in file")); 
        }
    }   
    
    return out;
  }
  
  
  // validator for a properly formed enemy JSON object
  Boolean validateEnemyJSONObject(JSONObject enemy) {
     return enemy.hasKey("x") && enemy.hasKey("y") && enemy.hasKey("image") &&  //<>//
           enemy.hasKey("projectileImage") && enemy.hasKey("projectileDamage")
           && enemy.hasKey("leftBoundary") && enemy.hasKey("rightBoundary") && enemy.hasKey("health")
           && enemy.hasKey("width") && enemy.hasKey("height");
  }
  
  // parses enemy JSON objects from the root JSON object
  ArrayList<Object> parseEnemyJSON() {
    ArrayList<Object> out = new ArrayList();
    JSONArray enemies = jsonRootObject.getJSONArray("enemies");
    for(int i = 0; i < enemies.size(); i++) {
       JSONObject enemyJSONObject = enemies.getJSONObject(i);
       if(validateEnemyJSONObject(enemyJSONObject)){
         String image, projectileImage;
         Integer x, y, projectileDamage, leftBoundary, rightBoundary, health, w, h;
         image = enemyJSONObject.getString("image");
         projectileImage = enemyJSONObject.getString("projectileImage");
         x = enemyJSONObject.getInt("x");
         y = enemyJSONObject.getInt("y");
         w = enemyJSONObject.getInt("width");
         h = enemyJSONObject.getInt("height");
         projectileDamage = enemyJSONObject.getInt("projectileDamage");
         leftBoundary = enemyJSONObject.getInt("leftBoundary");
         rightBoundary = enemyJSONObject.getInt("rightBoundary");
         health = enemyJSONObject.getInt("health");
         
         Enemy e = new Enemy(x, y, image, w, h, health, projectileImage, leftBoundary, rightBoundary);
         e.setProjectileDamage(projectileDamage);
         
         if(enemyJSONObject.hasKey("allowBounceAttack") && enemyJSONObject.getBoolean("allowBounceAttack") == false){
            e.disableBounceAttack(); 
         }
         out.add(e);
       } else {
          throw(new Error("missing required fields for enemy")); 
       }
    }
    return out;
  }
  
  // validates a health trigger JSON object has the proper fields
  Boolean validateHealthTriggerJSON(JSONObject json) {
    return json.hasKey("x") && json.hasKey("y") && 
          json.hasKey("imageLocation") && json.hasKey("value");
  }
  
  // creates a list of modifier triggers for the specified attribute from the specified nameSpace 
  ArrayList<Object> parseModifierTriggers(Player p, String jsonNameSpace, String attribute) {
      ArrayList<Object> out = new ArrayList();
      JSONArray healthTriggers = jsonRootObject.getJSONArray(jsonNameSpace);
      for(int i = 0; i < healthTriggers.size(); i++ ){
        JSONObject healthTriggerJSON = healthTriggers.getJSONObject(i);
        if(validateHealthTriggerJSON(healthTriggerJSON)){
           Integer x, y, value, w, h;
           PImage image = loadImage(healthTriggerJSON.getString("imageLocation"));
           x = healthTriggerJSON.getInt("x");
           y = healthTriggerJSON.getInt("y");
           value = healthTriggerJSON.getInt("value");
           if(healthTriggerJSON.hasKey("width") && healthTriggerJSON.hasKey("y")) {
              w = healthTriggerJSON.getInt("width");
              h = healthTriggerJSON.getInt("height");
           } else {
              w = image.width;
              h = image.height;
           }
           out.add(new ModifierTrigger(p, x, y, image, w, h, attribute, value));
 
        } else {
           throw(new Error("missing required fields for " + attribute + " modifier")); 
        }
      }
      return out;
  }
  
  // creates a world from the rootJSONObject
  World loadWorld(InputController inputController) {
    Player p = this.parsePlayerJSON();
    World theWorld = this.parseWorldJSON(p, inputController);
    ArrayList<Object> tiles = this.parseFloorJSON();
    theWorld.addAllObjects(tiles);
    ArrayList<Object> enemies = this.parseEnemyJSON();
    theWorld.addAllObjects(enemies); //<>//
    ArrayList<Object> triggers = parseTextTriggersJSON(p); //<>//
    triggers.addAll(parseGameOverTriggersJSON(p, theWorld));
    triggers.addAll(parseModifierTriggers(p, "healthModifiers", "health"));
    triggers.addAll(parseModifierTriggers(p, "scoreModifiers", "score"));
    theWorld.addAllObjects(triggers);
    
    return theWorld;
  }
}
