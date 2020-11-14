void keyPressed() {
  if (transitionStartTime == -1) {
    if (level != -1) {
      switch (key) {
        case 'w':
          pa.movePlayer(Direction.up);
        break;
        case 's':
          pa.movePlayer(Direction.down);
        break;
        case 'a':
          pa.movePlayer(Direction.left);
        break;
        case 'd':
          pa.movePlayer(Direction.right);
        break;
      }
      
      switch (keyCode) {
        case UP:
          pb.movePlayer(Direction.up);
        break;
        case DOWN:
          pb.movePlayer(Direction.down);
        break;
        case LEFT:
          pb.movePlayer(Direction.left);
        break;
        case RIGHT:
          pb.movePlayer(Direction.right);
        break;
      }
    } else {
      if (key == 'r') {
        level = -1;
        doneLevel(true);
      }
    }
  }
}
