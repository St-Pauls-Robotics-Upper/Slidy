import processing.sound.*;

PFont titleFont;
PFont bodyFont;
PFont captionFont;
PFont moveCounterFont;

PGraphics pg;

SoundFile blop;

void setup() {
  //load font
  titleFont = loadFont("AvenirNext-UltraLight-70.vlw");
  bodyFont = loadFont("AvenirNext-Regular-25.vlw");
  captionFont = loadFont("AvenirNext-DemiBold-15.vlw");
  moveCounterFont = loadFont("Apple-Chancery-40.vlw");
  
  //load sound
  blop = new SoundFile(this, "data/blop.mp3");
  
  //load level
  loadJsonObject();
  
  size(900, 700, P2D);
  //fullScreen(P2D);
  pg = createGraphics(900, 700, P3D);
  pg.pixelDensity = 2;
  pg.smooth(2);
  pixelDensity(2);
  smooth(2);
  //frameRate(5);
  loadData(level);
}

void draw() {
  background(0);
  render();
  //renderEndScreen();
}
