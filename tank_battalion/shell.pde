class Shell{
  static final int SIZE = 12;
  int x, y;
  int move_speed = 12;
  PImage shell_sprite;
  boolean up, down, left, right = false;
  
  public Shell(int tx, int ty, String direction){
    x = tx;
    y = ty;
    if(direction == "left"){
      left = true;
      x -= Player.SIZE / 2;
    }
    else if(direction == "right"){
      right = true;
      x += Player.SIZE / 2;
    }
    else if(direction == "up"){
      up = true;
      y -= Player.SIZE / 2;
    }
    else if(direction == "down"){
      down = true;
      y += Player.SIZE / 2;
    }
    shell_sprite = loadImage(SPRITES_FOLDER + "Shell.png");
  }
  
  void update() {
    if(up){
      y -= move_speed;
    }
    else if(down){
      y += move_speed;
    }
    else if(left){
      x -= move_speed;
    }
    else if(right){
      x += move_speed;
    }
  }
  
  void draw() {   
    image(shell_sprite, x, y, SIZE, SIZE);
  }
}
