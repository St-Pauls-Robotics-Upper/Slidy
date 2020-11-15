Players pa;
Players pb;

enum Direction { up, down, left, right}

class Players {
  int positionX, positionY;
  int identity;
  int maxAllowedTiles;
  int allowedFutureMoves;
  boolean havePendingTilings = false;
  
  float animatedPosX, animatedPosY, animatedHeight;
  
  Players(int positionX, int positionY, int identity, int maxAllowedMoves) {
    this.positionX = positionX;
    this.positionY = positionY;
    this.maxAllowedTiles = maxAllowedMoves + 1;
    this.identity = identity;
    
    mapBuffer[positionX][positionY] = identity;
    
    computeAvalableMoves();
  }
  
  void forcePosition() {
    animatedPosX = topLeftX + positionX * gridSize;
    animatedPosY = topLeftY + positionY * gridSize;
  }
  
  void movePlayer(Direction direction) {
    
    if (allowedFutureMoves == 0) {
      return;
    }
    int targetX = positionX;
    int targetY = positionY;
    switch(direction) {
      case up:
        targetY --;
      break;
      case down: 
        targetY ++;
      break;
      case left: 
        targetX --;
      break;
      case right: 
        targetX ++;
      break;
    }
    
    boolean canMoveSuccessfully = checkForMobilityTo(targetX, targetY);
    
    if (canMoveSuccessfully) {
      computeAvalableMoves();
      if (havePendingTilings) {
        layTile();
      }
      //play sound effect
      blop.rate(random(0.95,1.05));
      blop.play();
      
      //move it
      positionX = targetX;
      positionY = targetY;
      
      //lay tile at current position
      havePendingTilings = true;
    } else {
      blop.rate(0.5);
      blop.play();
    }
    
    playerMoved();
  }
  
  boolean checkForMobilityTo(int targetX, int targetY) {
    if (allowedFutureMoves == 0) {
      return false;
    }
    
    boolean canMoveSuccessfully = true;
    //y must be within range
    if (targetY < 0 || targetY >= mapSizeHeight) {
      canMoveSuccessfully = false;
    }
    //x must be within range
    if (targetX < 0 || targetX >= mapSizeWidth) {
      canMoveSuccessfully = false;
    }
    //it must not overlay another player
    if ((targetX == pa.positionX && targetY == pa.positionY) || (targetX == pb.positionX && targetY == pb.positionY)) {
      canMoveSuccessfully = false;
    }
    //it must be not on it selves body
    if (canMoveSuccessfully) {
      int targetTile = mapBuffer[targetX][targetY];
      if (targetTile == identity || targetTile == -1) {
        canMoveSuccessfully = false;
      }
    }
    return canMoveSuccessfully;
  }
  
  boolean checkForAllMobility() {
    
    boolean up = checkForMobilityTo(positionX, positionY - 1);
    boolean down = checkForMobilityTo(positionX, positionY + 1);
    boolean left = checkForMobilityTo(positionX - 1, positionY);
    boolean right = checkForMobilityTo(positionX + 1, positionY);
    
    return up || down || left || right;
  }
  
  void layTile() {
    mapBuffer[positionX][positionY] = identity;
    playerMoved();
  }
  
  void computeAvalableMoves() {
    int usedSpace = havePendingTilings ? 1 : 0;
    for (int[] colum: mapBuffer) {
      for (int element: colum) {
        if (element == identity) {
          usedSpace ++;
        }
      }
    }
    allowedFutureMoves = maxAllowedTiles - usedSpace;
  }
  
  void render() {
    int worldPositionX = topLeftX + positionX * gridSize;
    int worldPositionY = topLeftY + positionY * gridSize;
    
    float factor = 0.2;
    animatedPosX += ((float)worldPositionX - animatedPosX) * factor;
    animatedPosY += ((float)worldPositionY - animatedPosY) * factor;
    
    float difference = abs(animatedPosX - worldPositionX) + abs(animatedPosY - worldPositionY);
    
    if (difference <= 1.0) {
      forcePosition();
      if (havePendingTilings) {
        havePendingTilings = false;
        layTile();
      }
    }
    
    if (allowedFutureMoves > 0) {
      if (identity == 1) {
        pg.stroke(200,200,255);
        pg.fill(0,0,255);
      }
      if (identity == 2) {
        pg.stroke(255,200,200);
        pg.fill(255,0,0);
      }
    } else {
      if (identity == 1) {
        pg.stroke(255,200,200);
        pg.fill(100,100,255);
      }
      if (identity == 2) {
        pg.stroke(255,200,200);
        pg.fill(255,100,100);
      }
    }
    
    pg.rect(animatedPosX, animatedPosY, gridSize, gridSize);
    
    
    Float baseHeight = 20.0;
    Float maxHeight = 100.0;
    Float extendedRatio = 0.0;
    if (maxAllowedTiles > 0) {
      extendedRatio = allowedFutureMoves / (maxAllowedTiles - 1.0);
    }
    Float playerHeight = baseHeight + (maxHeight - baseHeight) * extendedRatio;
    
    animatedHeight += ((float)playerHeight - animatedHeight) * 0.1;
    
    pg.pushMatrix();
    pg.translate(animatedPosX + gridSize/2, animatedPosY + gridSize/2, animatedHeight/2);
    pg.box(gridSize - 10, gridSize - 10, animatedHeight);
    pg.popMatrix();
    
    pg.pushMatrix();
    pg.translate(0, 0, animatedHeight + 0.01);
    pg.textFont(bodyFont);
    pg.fill(0, allowedFutureMoves == 0 ? 50 : 255);
    pg.text(allowedFutureMoves, animatedPosX + gridSize/2 - pg.textWidth(allowedFutureMoves + "")/2, animatedPosY + 40);
    pg.popMatrix();
  }
}

void playerMoved() {
  pa.computeAvalableMoves();
  pb.computeAvalableMoves();
  
  //end detection
  if (!pa.havePendingTilings && !pb.havePendingTilings && transitionStartTime != 1) {
    boolean distanceReached = (abs(pa.positionX - pb.positionX) + abs(pa.positionY - pb.positionY)) == 1;
    boolean countReached = pa.allowedFutureMoves == 0 && pb.allowedFutureMoves == 0;
    if (countReached && distanceReached) {
      doneLevel(true);
      return;
    }
    if (countReached && !distanceReached) {
      doneLevel(false);
      return;
    }
    if (!pa.checkForAllMobility() && !pb.checkForAllMobility()) {
      doneLevel(false);
    }
  }
}
