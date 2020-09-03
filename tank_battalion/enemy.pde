class Enemy {
  static final int SIZE = 64;
  int x, y;
  int move_speed = 3;
  
  final String SPRITES_FOLDER = "../assets/sprites/";
  PImage enemy_up, enemy_down, enemy_left, enemy_right, actual_image;
  
  Enemy(int xpos, int ypos){
    x = xpos;
    y = ypos;
    enemy_up = loadImage(SPRITES_FOLDER + "EnemyUp.png");
    enemy_down = loadImage(SPRITES_FOLDER + "EnemyDown.png");
    enemy_left = loadImage(SPRITES_FOLDER + "EnemyLeft.png");
    enemy_right = loadImage(SPRITES_FOLDER + "EnemyRight.png");
    actual_image = enemy_down;
  }
  
  void update(int[][] grid_nodes) {
    int target_x = x;
    int target_y = y;
    int direction = -1; //int(random(0, 4));
    if(direction == 1){
      actual_image = enemy_up;
      target_y -= move_speed;
    }
    else if(direction == 2){
      actual_image = enemy_down;
      target_y += move_speed;
    }
    else if(direction == 3){
      actual_image = enemy_left;
      target_x -= move_speed;
    }
    else if(direction == 4){
      actual_image = enemy_right;
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
    image(actual_image, x, y, SIZE, SIZE);
  }
}
