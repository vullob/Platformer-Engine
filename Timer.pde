/*
  Timer - a timer for the world

  Brian Vullo
*/
class Timer {
  int timeStarted, timeStopped; // the time started and stopped in millis
  Boolean stopped = false; // are we still running?
  
  Timer() {
     this.timeStarted = millis(); 
  }
  
  // starts the timer
  void startTimer() {
     stopped = false;
     this.timeStarted = millis();
  }
  
  // get the current time as a string
  String getCurrentTime() {
     int currentMillis = stopped ? timeStopped - timeStarted : millis() - timeStarted;
     int seconds = (currentMillis / 1000) % 60;
     int minutes = (currentMillis/ 60000)% 60;
     int hours = (currentMillis / 3600000) % 24;
     String out = "" + minutes + ":" + (seconds >= 10 ? seconds : "0" + seconds);
     return hours > 0 ? "" + hours + ":" + out : out;     
  }
  
  // stop the timer
  void stopTimer() {
     this.timeStopped = millis();
     stopped = true;
  }
}
