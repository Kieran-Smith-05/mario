void intro() {
  
  background(#00e677);
  textAlign(CENTER, CENTER);
  textSize(100);
  fill(0);
  text("BEEP", 300, 250);
  
  if (keyPressed == true) {
    mode = GAME;
  }
}
