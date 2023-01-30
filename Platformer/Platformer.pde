import fisica.*;
FWorld world;


final int INTRO = 1;
final int GAME = 2;
final int GAMEOVER = 3;

int mode;



color white = #FFFFFF;
color black = #000000;
color green = #a6e61d;
color red = #FF0000;
color blue = #0000FF;
color orange = #F0A000;
color brown = #996633;
color cyan = #2ea7db;
color yellow = #f3f725;
color purple = #9c27b0;
color grey = #9e9e9e;
color dBlue = #3f51b5;
color dGreen = #8bc34a;
color lRed = #d50000;
color dGrey = #424242;

PImage map, ice, stone, treeTrunk, treeEndWest, treeEndEast, treeMiddle, treeIntersect, spike, bridge, hammer, trampoline;
//mario animations
PImage[] idle;
PImage[] jump;
PImage[] run;
PImage[] action;

PImage[] goomba;
PImage[] lava;
PImage[] thwomp;
PImage[] hammerbro;

boolean mouseReleased;
boolean wasPressed;


int gridSize = 32;
float zoom = 1.5;
int randomLava = (int) random(0, 5);
boolean wkey, akey, skey, dkey, upkey, downkey, rightkey, leftkey;
FPlayer player;
ArrayList<FGameObject> terrain;
ArrayList<FGameObject> enemies;

void setup() {
  size(600, 600);
  mode = INTRO;
  Fisica.init(this);
  terrain = new ArrayList<FGameObject>();
  enemies = new ArrayList<FGameObject>();
  //load actions
  idle = new PImage[2];
  idle[0] = loadImage("idle0.png");
  idle[1] = loadImage("idle1.png");

  jump = new PImage[1];
  jump[0] = loadImage("jump0.png");

  run = new PImage[3];
  run[0] = loadImage("runright0.png");
  run[1] = loadImage("runright1.png");
  run[2] = loadImage("runright2.png");

  lava = new PImage[6];
  lava[0] = loadImage("lava0.png");
  lava[1] = loadImage("lava1.png");
  lava[2] = loadImage("lava2.png");
  lava[3] = loadImage("lava3.png");
  lava[4] = loadImage("lava4.png");
  lava[5] = loadImage("lava5.png");

  thwomp = new PImage[2];
  thwomp[0] = loadImage("thwomp0.png");
  thwomp[1] = loadImage("thwomp1.png");

  hammerbro = new PImage[2];
  hammerbro[0] = loadImage("hammerbro0.png");
  hammerbro[1] = loadImage("hammerbro1.png");

  goomba = new PImage[2];
  goomba[0] = loadImage("goomba0.png");
  goomba[0].resize(gridSize, gridSize);
  goomba[1] = loadImage("goomba1.png");
  goomba[1].resize(gridSize, gridSize);

  action = idle;

  map = loadImage("map.png");
  stone = loadImage("brick.png");
  ice = loadImage("ice.png");
  treeTrunk = loadImage("tree_trunk.png");
  ice.resize(32, 32);
  treeIntersect = loadImage("tree_intersect.png");
  treeMiddle = loadImage("treetop_center.png");
  treeEndEast = loadImage("treetop_e.png");
  treeEndWest = loadImage("treetop_w.png");
  spike = loadImage("spike.png");
  bridge = loadImage("bridge.png");
  hammer = loadImage("hammer.png");
  trampoline = loadImage("trampoline.png");
  loadWorld(map);
  loadPlayer();
}


void loadPlayer() {
  player = new FPlayer();
  world.add(player);
}


void loadWorld(PImage img) {
  world = new FWorld(-2000, -2000, 2000, 2000);
  world.setGravity(0, 900);


  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      color c = img.get(x, y);
      color s = img.get(x, y+1);
      color w = img.get(x-1, y);
      color e = img.get(x+1, y);
      FBox b = new FBox(gridSize, gridSize);
      b.setPosition(x*gridSize, y*gridSize);
      b.setStatic(true);
      if (c == black) {
        b.setFriction(4);
        b.attachImage(stone);
        b.setName("stone");
        world.add(b);
      } else if (c == grey) {
        b.attachImage(stone);
        b.setName("wall");
        world.add(b);
      } else if (c == cyan) { //ice block
        b.attachImage(ice);
        b.setFriction(0);
        b.setName("ice");
        world.add(b);
      } else if (c == brown) { //ice block
        b.attachImage(treeTrunk);
        b.setSensor(true);
        b.setName("tree trunk");
        world.add(b);
      } else if (c == green && s == brown) { //ice block
        b.attachImage(treeIntersect);
        b.setName("tree top");
        world.add(b);
      } else if (c == green && w == green & e == green && s !=brown) { //ice block
        b.attachImage(treeMiddle);
        b.setName("tree top");
        world.add(b);
      } else if (c == green && w != green) { //ice block
        b.attachImage(treeEndWest);
        b.setName("tree top");
        world.add(b);
      } else if (c == green && e != green) { //ice block
        b.attachImage(treeEndEast);
        b.setName("tree top");
        world.add(b);
      } else if (c == orange) {
        b.attachImage(spike);
        b.setName("spike");
        world.add(b);
      } else if (c == yellow) {
        FBridge br = new FBridge(x*gridSize, y*gridSize);
        terrain.add(br);
        world.add(br);
      } else if (c == purple) {
        FGoomba gmb = new FGoomba(x*gridSize, y*gridSize);
        enemies.add(gmb);
        world.add(gmb);
      } else if (c == lRed) {
        FLava lav = new FLava(x*gridSize, y*gridSize);
        terrain.add(lav);
        world.add(lav);
      } else if (c == dBlue) {
        FThwomp thw = new FThwomp(x*gridSize, y*gridSize);
        enemies.add(thw);
        world.add(thw);
      } else if (c == dGreen) {
        FHammerBro ham = new FHammerBro(x*gridSize, y*gridSize);
        enemies.add(ham);
        world.add(ham);
      } else if (c == dGrey) {
        b.attachImage(trampoline);
        b.setName("trampoline");
        b.setFriction(4);
        b.setRestitution(1.3);
        world.add(b);
      }
    }
  }
}

void draw() {
  click();
  
  if (mode == INTRO) {
    intro();
  } else if ( mode == GAME) {
    game();
  } else if (mode == GAMEOVER) {
    gameover();
  }
 
  actWorld();
 
}


void actWorld() {
  player.act();
  for (int i = 0; i < terrain.size(); i++) {
    FGameObject t = terrain.get(i);
    t.act();
  }
  for (int i = 0; i < enemies.size(); i++) {
    FGameObject e = enemies.get(i);
    e.act();
  }
}

void drawWorld() {
  pushMatrix();
  translate(-player.getX()*zoom+width/2, -player.getY()*zoom+height/2);
  scale(zoom);
  world.step();
  world.draw();
  popMatrix();
}
