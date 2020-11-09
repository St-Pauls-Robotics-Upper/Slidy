PFont largeTitleFont;
PFont moveCounterFont;

void setup() {
  largeTitleFont = loadFont("AvenirNext-UltraLight-70.vlw");
  moveCounterFont = loadFont("Apple-Chancery-40.vlw");
  
  size(900,700,P2D);
  pixelDensity(2);
  smooth(4);
  //frameRate(5);
  loadData(0);
}

void draw() {
  background(0);
  render();
}
