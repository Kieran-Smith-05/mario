class FLava extends FGameObject {
  int f = 0;
  //int speed;
  FLava(float x, float y) {
    super();
    setPosition(x, y);
    setName("lava");
    setStatic(true);
    //speed = sped;
  }
  
  void act() {
    
    if (frameCount %12 == 0) {
      randomLava = (int) random (0, 5);
      attachImage(lava[randomLava]);
    }
  }
}
