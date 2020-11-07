int[][] mapBuffer = new int[10][7];
int gridSize = 64;

int mapSizeWidth, mapSizeHeight;
int mapWidth, mapHeight;
int topLeftX, topLeftY;

void updateMap() {
  mapSizeWidth = mapBuffer.length;
  mapSizeHeight = mapBuffer[0].length;
  
  mapWidth = mapSizeWidth * gridSize;
  mapHeight = mapSizeHeight * gridSize;
  
  topLeftX = (width - mapWidth)/2;
  topLeftY = (height - mapHeight)/2;
}

void drawGameBoard() {
  for (int ix = 0; ix < mapSizeWidth; ix++) {
    for (int iy = 0; iy < mapSizeHeight; iy++) {
      int drawingX = topLeftX + ix * gridSize;
      int drawingY = topLeftY + iy * gridSize;
      
      //draw baclgroundGrid
      stroke(30);
      fill(0);
      rect(drawingX, drawingY, gridSize, gridSize);
      
      //draw trial
      int bufferValue = mapBuffer[ix][iy];
      switch (bufferValue) {
        case 1:
          noStroke();
          fill(100,100,200);
          rect(drawingX, drawingY, gridSize, gridSize);
        break;
        case 2:
          noStroke();
          fill(200,100,100);
          rect(drawingX, drawingY, gridSize, gridSize);
        break;
      }
    }
  }
}
