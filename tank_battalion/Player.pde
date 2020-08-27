class Player {
  int x, y;
  
  boolean up, down, left, right = false;
  
  final String SPRITES_FOLDER = "../assets/sprites/";
  
  PImage player_up, player_down, player_left, player_right, tank_image;
  
  Player(int xpos, int ypos) {
    x = xpos;
    y = ypos;
    player_up = loadImage(SPRITES_FOLDER + "PlayerUp.png");
    player_down = loadImage(SPRITES_FOLDER + "PlayerDown.png");
    player_left = loadImage(SPRITES_FOLDER + "PlayerLeft.png");
    player_right = loadImage(SPRITES_FOLDER + "PlayerRight.png");
    tank_image = player_up;
  }
  
  void input(int k, boolean value){
    switch(k) {
      case UP:
        up = value;
        break;
      
      case DOWN:
        down = value;
        break;
        
      case LEFT:
        left = value;
        break;
        
      case RIGHT:
        right = value;
        break;
    }
  }
  
  void draw() {
    if(up){
      tank_image = player_up;
      y -= 2;
    }
    else if(down){
      tank_image = player_down;
      y += 2;
    }
    else if(left){
      tank_image = player_left;
      x -= 2;
    }
    else if(right){
      tank_image = player_right;
      x += 2;
    }
    rectMode(CENTER);
    image(tank_image, x, y, 64, 64);
  }
}
