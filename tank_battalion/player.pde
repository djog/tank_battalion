class Player {
  static final int SIZE = 64;
  
  int x, y;
  int move_speed = 3;
  
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
      case 'w':
      case 'W':
        up = value;
        break;
      
      case DOWN:
      case 's':
      case 'S':
        down = value;
        break;
        
      case LEFT:
      case 'a':
      case 'A':
        left = value;
        break;
        
      case RIGHT:
      case 'd':
      case 'D':
        right = value;
        break;
    }
  }
  
  void update(int[][] grid_nodes) {
    int target_x = x;
    int target_y = y;
    if(up){
      tank_image = player_up;
      target_y -= move_speed;
    }
    else if(down){
      tank_image = player_down;
      target_y += move_speed;
    }
    else if(left){
      tank_image = player_left;
      target_x -= move_speed;
    }
    else if(right){
      tank_image = player_right;
      target_x += move_speed;
    }
    // Only move the player if the target position does not hit an obstacle
    if (!collision_detection(target_x, target_y, SIZE, SIZE, grid_nodes))
    {
      x = target_x;
      y = target_y;
    }
  }
  
  void draw() {   
    imageMode(CENTER);
    image(tank_image, x, y, SIZE, SIZE);
  }
}
