int level = 0;
float transitionStartTime = -1;
float transitionDuration = 1000;
boolean transitionalToBlack = false;

float transitionTimer() {
  return transitionStartTime - millis() + transitionDuration;
}

void doneLevel(boolean finishLevel) {
  transitionStartTime = millis();
  transitionalToBlack = true;
}

void render() {
  renderGame();
  float countdown = transitionTimer();
  if (transitionStartTime != -1) {
    if (transitionalToBlack) {
      renderSpash((1 - (countdown/transitionDuration)) * 255);
    }
    if (!transitionalToBlack) {
      renderSpash((countdown/transitionDuration) * 255);
    }
    
    if (countdown <= 0) {
      if (transitionalToBlack) {
        transitionalToBlack = false;
        transitionStartTime = millis();
        loadData(1);
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
}
void renderGame() {
  drawGameBoard();
  pa.render();
  pb.render();
  stroke(255);
  fill(0,0);
  rect(topLeftX, topLeftY, mapWidth, mapHeight);
}
