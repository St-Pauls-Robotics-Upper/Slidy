Players pa;
Players pb;

enum Direction { up, down, left, right}

class Players {
  int positionX, positionY;
  int identity;
  int maxAllowedTiles;
  int allowedFutureMoves;
  boolean havePendingTilings = false;
  
  float animatedPosX, animatedPosY;
  
  Players(int positionX, int positionY, int identity, int maxAllowedMoves) {
    this.positionX = positionX;
    this.positionY = positionY;
    this.maxAllowedTiles = maxAllowedMoves + 1;
    this.identity = identity;
    
    layTile();
  }
  
  void forcePosition() {
    animatedPosX = topLeftX + positionX * gridSize;
    animatedPosY = topLeftY + positionY * gridSize;
  }
  
  void movePlayer(Direction direction) {
    if (allowedFutureMoves == 0) {
      return;
    } 
    
    boolean canMoveSuccessfully = true;
    //move
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
    
    if (canMoveSuccessfully) {
      computeAvalableMoves();
      if (havePendingTilings) {
        layTile();
      }
      
      //move it
      positionX = targetX;
      positionY = targetY;
      
      //lay tile at current position
      havePendingTilings = true;
    }
    
    playerMoved();
  }
  
  void layTile() {
    mapBuffer[positionX][positionY] = identity;
    computeAvalableMoves();
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
    
    float factor = 10/frameRate;
    animatedPosX += ((float)worldPositionX - animatedPosX) * factor;
    animatedPosY += ((float)worldPositionY - animatedPosY) * factor;
    
    float difference = abs(animatedPosX - worldPositionX) + abs(animatedPosY - worldPositionY);
    
    if (difference <= 1.0) {
      forcePosition();
      havePendingTilings = false;
      layTile();
    }
    
    if (allowedFutureMoves > 0) {
      if (identity == 1) {
        stroke(100,100,255);
        fill(0,0,255);
      }
      if (identity == 2) {
        stroke(255,100,100);
        fill(255,0,0);
      }
    } else {
      if (identity == 1) {
        noStroke();
        fill(100,100,255);
      }
      if (identity == 2) {
        noStroke();
        fill(255,100,100);
      }
    }
    rect(animatedPosX, animatedPosY, gridSize, gridSize);
    fill(0);
    text(allowedFutureMoves, animatedPosX + 10, animatedPosY + 20);
  }
}

void playerMoved() {
  pa.computeAvalableMoves();
  pb.computeAvalableMoves();
  
  //end detection
  if (pa.allowedFutureMoves == 0 && pb.allowedFutureMoves == 0) {
    int distance = abs(pa.positionX - pb.positionX) + abs(pa.positionY - pb.positionY);
    if (distance == 1) {
      print("Complete");
    } else {
      print("failed");
    }
  }
}
