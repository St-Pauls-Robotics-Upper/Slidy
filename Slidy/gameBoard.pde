int[][] mapBuffer;
int gridSize = 64;

int mapSizeWidth, mapSizeHeight;
int mapWidth, mapHeight;
int topLeftX, topLeftY;

String worldName = "";

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
      pg.stroke(30);
      pg.fill(255);
      pg.rect(drawingX, drawingY, gridSize, gridSize);
      
      //draw trial
      int bufferValue = mapBuffer[ix][iy];
      switch (bufferValue) {
        case 1:
          pg.noStroke();
          pg.fill(100,100,200);
          pg.rect(drawingX, drawingY, gridSize, gridSize);
        break;
        case 2:
          pg.noStroke();
          pg.fill(200,100,100);
          pg.rect(drawingX, drawingY, gridSize, gridSize);
        break;
        case -1:
          pg.stroke(255);
          pg.fill(100,100,105);
          //rect(drawingX, drawingY, gridSize, gridSize);
          
          pg.pushMatrix();
          pg.translate(drawingX + gridSize/2, drawingY + gridSize/2);
          pg.box(gridSize, gridSize, 200);
          pg.popMatrix();
          
        break;
      }
    }
  }
}

void loadData(int file) {
  String[] lines = loadStrings("maps/map" + file + ".txt");
  //load world telemetry
  worldName = lines[0];
  
  String firstLine = lines[1];
  String[] firstSplit = firstLine.split(",");
  mapBuffer = new int[Integer.parseInt(firstSplit[0])][Integer.parseInt(firstSplit[1])];
  //load playerA telemetry
  String secondLine = lines[2];
  String[] secondSplit = secondLine.split(",");
  pa = new Players(Integer.parseInt(secondSplit[0]),Integer.parseInt(secondSplit[1]),1,Integer.parseInt(secondSplit[2]));
  //load playerB telemetry
  String thirdLine = lines[3];
  String[] thirdSplit = thirdLine.split(",");
  pb = new Players(Integer.parseInt(thirdSplit[0]),Integer.parseInt(thirdSplit[1]),2,Integer.parseInt(thirdSplit[2]));
  //load map data
  
  updateMap();
  for (int iy = 0; iy < lines.length - 4; iy++) {
    int yValueInString = iy + 4;
    String line = lines[yValueInString];
    for (int ix = 0; ix < line.length(); ix++) {
      char character = line.charAt(ix);
      switch (character) {
        case 'x':
          mapBuffer[ix][iy] = -1;
        break;
        default: 
          //mapBuffer[ix][iy] = 0;
        break;
      }
    }
  }
  
  pa.forcePosition();
  pb.forcePosition();
}
