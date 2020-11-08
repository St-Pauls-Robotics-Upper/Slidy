void keyPressed() {
  if (transitionStartTime != -1) {
    return;
  }
  
  switch (keyCode) {
    case 87: //w
      pa.movePlayer(Direction.up);
    break;
    case 83: //s
      pa.movePlayer(Direction.down);
    break;
    case 65: //a
      pa.movePlayer(Direction.left);
    break;
    case 68: //d
      pa.movePlayer(Direction.right);
    break;
    
    case 38: //up
      pb.movePlayer(Direction.up);
    break;
    case 40: //down
      pb.movePlayer(Direction.down);
    break;
    case 37: //left
      pb.movePlayer(Direction.left);
    break;
    case 39: //right
      pb.movePlayer(Direction.right);
    break;
  }
}
