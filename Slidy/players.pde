Players pa = new Players(1,1,1,8);
Players pb = new Players(8,5,2,8);

enum Direction { up, down, left, right}

class Players {
  int positionX, positionY;
  int identity;
  int maxAllowedTiles;
  int allowedFutureMoves;
  
  Players(int positionX, int positionY, int identity, int maxAllowedMoves) {
    this.positionX = positionX;
    this.positionY = positionY;
    this.maxAllowedTiles = maxAllowedMoves + 1;
    this.identity = identity;
    layTile();
    computeAvalableMoves();
  }
  
  void movePlayer(Direction direction) {
    computeAvalableMoves();
    if (allowedFutureMoves == 0) {
      return;
    } 
    
    boolean canMoveSuccessfully = true;
    int lastX = positionX;
    int lastY = positionY;
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
    int targetTile = mapBuffer[targetX][targetY];
    if (targetTile == identity || targetTile == -1) {
      canMoveSuccessfully = false;
    }
    
    if (canMoveSuccessfully) {
      //move it
      positionX = targetX;
      positionY = targetY;
      
      //lay tile at current position
      layTile();
    }
    
    playerMoved();
  }
  
  void layTile() {
    mapBuffer[positionX][positionY] = identity;
  }
  
  void computeAvalableMoves() {
    int usedSpace = 0;
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
    rect(worldPositionX, worldPositionY, gridSize, gridSize);
    fill(0);
    text(allowedFutureMoves, worldPositionX + 10, worldPositionY + 20);
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
