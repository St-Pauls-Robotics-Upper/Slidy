int level = 0;//start-up level, used for debug, set to 0 for release
float transitionStartTime = -1;
float transitionDuration = 800;
boolean transitionalToBlack = false;
boolean transitionalToNextLevel = true;
boolean transitionalToEnd = false;

int numberOfLevels = 5; //this is the total number of levels, set to your last number of map file

float transitionTimer() {
  return min(max(transitionStartTime - millis() + transitionDuration, 0), transitionDuration);
}

void doneLevel(boolean finishLevel) {
  transitionalToBlack = true;
  transitionalToNextLevel = finishLevel;
  transitionStartTime = millis();
}

void render() {
  
  if (transitionalToEnd) {
    renderEndScreen();
  } else {
    renderGame();
  }
  
  float countdown = transitionTimer();
  if (transitionStartTime != -1) {
    float ratio = countdown/transitionDuration;
    
    if (transitionalToBlack) {
      renderSpash((1 - ratio) * 255);
    } else {
      renderSpash(ratio * 255);
    }
    
    if (countdown <= 0) {
      if (transitionalToBlack) {
        transitionalToBlack = false;
        transitionStartTime = millis();
        
        if(level == numberOfLevels && transitionalToNextLevel) {
          transitionalToEnd = true;
          //exit();
        } else {
          if (transitionalToNextLevel) level ++;
          loadData(level);
        }
      } else {
        transitionStartTime = -1;
      }
    }
  }
}

void renderSpash(float opacity) {
  fill(0, opacity);
  noStroke();
  rect(0,0,width,height);
  if (transitionalToNextLevel) {
  } else {
    fill(255, opacity);
    centerAlignedWord("TRY AGAIN", height/2, FontSize.title);
  }
}

void renderEndScreen() {
  fill(255);
  centerAlignedWord("Thanks for Playing Slidy", 400, FontSize.title);
}

void renderGame() {
  pg.beginDraw();
  pg.background(0);
  
  float zoomOutForY = max(0, (mapSizeHeight - 7) * 70);
  float zoomOutForX = max(0, (mapSizeWidth - 11) * 45);
  
  float zoom = max(zoomOutForY, zoomOutForX);
  pg.camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0) + zoom, width/2.0, height/2.0, 0, 0, 1, 0);
  drawGameBoard();
  pa.render();
  pb.render();
  pg.stroke(255);
  pg.fill(0,0);
  pg.rect(topLeftX, topLeftY, mapWidth, mapHeight);
  pg.endDraw();
  image(pg,0,0);
  
  fill(255);
  //textFont(largeTitleFont);
  //String content = worldName;
  //text(content, (width - textWidth(content))/2, 60);
  centerAlignedWord(worldName, 65, FontSize.title);
}
