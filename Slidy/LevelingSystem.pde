int level = 0;
float transitionStartTime = -1;
float transitionDuration = 1000;
boolean transitionalToBlack = false;
boolean transitionalToNextLevel = true;

float transitionTimer() {
  return min(max(transitionStartTime - millis() + transitionDuration, 0), transitionDuration);
}

void doneLevel(boolean finishLevel) {
  transitionalToBlack = true;
  transitionalToNextLevel = finishLevel;
  transitionStartTime = millis();
  
  if(level == 3 && finishLevel) {
    //change the level == 3 to maximum leves
    exit();
  }
}

void render() {
  
  renderGame();
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
        if (transitionalToNextLevel) level ++;
        
        loadData(level);
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
    textFont(largeTitleFont);
    String content = "TRY AGAIN";
    text(content, (width - textWidth(content))/2, height/2);
  }
}

void renderGame() {
  pg.beginDraw();
  pg.background(0);
  drawGameBoard();
  pa.render();
  pb.render();
  pg.stroke(255);
  pg.fill(0,0);
  pg.rect(topLeftX, topLeftY, mapWidth, mapHeight);
  pg.endDraw();
  image(pg,0,0);
  
  fill(255);
  textFont(largeTitleFont);
  String content = worldName;
  text(content, (width - textWidth(content))/2, 60);
}
