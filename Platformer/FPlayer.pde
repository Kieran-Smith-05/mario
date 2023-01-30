class FPlayer extends FGameObject {
  int frame;
  int direction;



  FPlayer() {
    super();
    frame = 0;
    direction = R;
    setPosition(250, 0);
    setName("player");
    setRotatable(false);
    setFillColor(red);
  }

  void act() {
    handleInput();
    animate();
    if (isTouching("spike")) {
      setPosition(0, 0);
    }
  }

  void animate() {
    if (frame >= action.length) frame = 0;
    if (frameCount % 5 ==0) {
      if (direction == R) attachImage(action[frame]);
      if (direction == L) attachImage(reverseImage(action[frame]));
      frame++;
    }
  }


  void handleInput() {
    float vy = getVelocityY();
    float vx = getVelocityX();
    if (abs(vy) < 0.1) {
      action = idle;
    }
    if (dkey) {
      setVelocity(200, vy);
      action = run;
      direction = R;
    }
    if (akey) {
      setVelocity(-200, vy);
      action = run;
      direction = L;
    }
    //if (wkey) {
    //  setVelocity(vx, -200);
    if (abs(vy) > 0.1) {
      action = jump;
    }
    jumping();
  }


  void jumping() {
    float vx = getVelocityX();
    ArrayList<FContact> jump = getContacts();

    for (int i = 0; i < jump.size(); i++) {
      FContact j = jump.get(i);
      if (j.contains("stone")) {
        if (wkey) {
          setVelocity(vx, -400);
        }
      } else if (j.contains("ice")) {
        if (wkey) {
          setVelocity(vx, -400);
        }
      } else if (j.contains("spike")) {
        if (wkey) {
          setVelocity(vx, -400);
        }
      } else if (j.contains("bridge")) {
        if (wkey) {
          setVelocity(vx, -400);
        }
      } else if (j.contains("tree top")) {
        if (wkey) {
          setVelocity(vx, -400);
        }
      }
    }
  }
}
