void setup() {
  size(900,700,P2D);
  pixelDensity(2);
  smooth(2);
  updateMap();
}

void draw() {
  background(0);
  drawGameBoard();
  pa.render();
  pb.render();
  stroke(255);
  fill(0,0);
  rect(topLeftX, topLeftY, mapWidth, mapHeight);
}
