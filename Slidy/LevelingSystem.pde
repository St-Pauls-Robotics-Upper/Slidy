int level = 0;//start-up level, used for debug, set to 0 for release
float transitionStartTime = -1;
float transitionDuration = 0;
boolean transitionalToBlack = false;
boolean transitionalToNextLevel = true;

int numberOfLevels = 17; //this is the total number of levels, set to your last number of map file

float transitionTimer() {
  return min(max(transitionStartTime - millis() + transitionDuration, 0), transitionDuration);
}

void loadJsonObject() {
  JSONObject levelJSON = new JSONObject();
  levelJSON = loadJSONObject("data/level.json");
  level = levelJSON.getInt("level");
}

void saveLevelJson() {
  JSONObject levelJSON = new JSONObject();
  int savedLevel = max(0, level);
  levelJSON.setInt("level", savedLevel);
  saveJSONObject(levelJSON, "data/level.json");
}

void doneLevel(boolean finishLevel) {
  if (!finishLevel) {
    transitionDuration = 800;
  } else {
    transitionDuration = 2000;
  }
  
  transitionalToBlack = true;
  transitionalToNextLevel = finishLevel;
  transitionStartTime = millis();
}

void render() {
  
  if (level == -1) {
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
          level = -1;
          //exit();
        } else {
          if (transitionalToNextLevel) level ++;
          loadData(level);
        }
        
        saveLevelJson();
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
  int titleBlockY = 200;
  centerAlignedWord("Thanks for Playing Slidy", titleBlockY, FontSize.title);
  
  int creditBlockY = 300;
  centerAlignedWord("TEAM G2C2", creditBlockY, FontSize.body);
  centerAlignedWord("Yuanda Liu", creditBlockY + 22, FontSize.caption);
  centerAlignedWord("Jingchen Jiang", creditBlockY + 42, FontSize.caption);
  centerAlignedWord("Caitlin F", creditBlockY + 62, FontSize.caption);
  centerAlignedWord("Mingzhou(August) Ou", creditBlockY + 82, FontSize.caption);
  centerAlignedWord("Tate S", creditBlockY + 102, FontSize.caption);
  
  fill(100);
  centerAlignedWord("Press R to play again", height - 20, FontSize.caption);
}

void startBGM() {
  bgm = new SoundFile(this, "data/bgm.mp3");
  bgm.loop();
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
  
  //display hints
  if (level == 0) {
    firstHint();
  }
  switch(level) {
    case 0:
      firstHint();
    break;
    case 1: 
      secondHint();
    break;
    case 2:
      thirdHint();
    break;
  }
}

void firstHint() {
  fill(255);
  centerAlignedWord("Blue - W S A D   Red - UP DOWN LEFT RIGHT", 500, FontSize.caption);
  
  fill(200);
  centerAlignedWord("RULE 1", 600, FontSize.caption);
  centerAlignedWord("Void with Joint is the Critical Point", 620, FontSize.caption);
}

void secondHint() {
  fill(200);
  centerAlignedWord("RULE 2", 600, FontSize.caption);
  centerAlignedWord("Void without Joint ment the Endding Point", 620, FontSize.caption);
  centerAlignedWord("Joint without Void ment the Disappoint", 640, FontSize.caption);
}

void thirdHint() {
  fill(200);
  centerAlignedWord("RULE 3", 600, FontSize.caption);
  centerAlignedWord("Inlet your Cassette is never Accepted", 620, FontSize.caption);
  centerAlignedWord("Inset the Assets of your Friend is a Smart Set", 640, FontSize.caption);
}
