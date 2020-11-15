import processing.sound.*;

PFont titleFont;
PFont bodyFont;
PFont captionFont;
PFont moveCounterFont;

PGraphics pg;

SoundFile blop;
SoundFile bgm;

void setup() {
  //load font
  titleFont = loadFont("AvenirNext-UltraLight-70.vlw");
  bodyFont = loadFont("AvenirNext-Regular-25.vlw");
  captionFont = loadFont("AvenirNext-DemiBold-15.vlw");
  moveCounterFont = loadFont("Apple-Chancery-40.vlw");
  
  //load sound
  blop = new SoundFile(this, "data/blop.mp3");
  
  thread("startBGM");
  
  //load level
  loadJsonObject();
  
  size(900, 700, P2D);
  //fullScreen(P2D);
  pixelDensity(2);
  smooth(2);
  
  pg = createGraphics(width, height, P3D);
  pg.pixelDensity = pixelDensity;
  pg.smooth(2);
  //frameRate(5);
  loadData(level);
}

void startBGM() {
  bgm = new SoundFile(this, "data/bgm.mp3");
  bgm.amp(0.3);
  bgm.loop();
}

void draw() {
  
  
  background(0);
  render();
  //renderEndScreen();
}
