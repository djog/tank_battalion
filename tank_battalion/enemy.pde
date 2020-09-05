class Enemy {
  static final int SIZE = 64;
  int x, y;
  int move_speed = 3;
  int collider_id;
  
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
    collider_id = physics_manager.get_collider_id();
  }
  
  void update() {
    int target_x = x;
    int target_y = y;
    int direction = int(random(0, 5));
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
    if (!physics_manager.check_collision(target_x, target_y, SIZE, SIZE, collider_id))
    {
      x = target_x;
      y = target_y;
    }
    physics_manager.update_collider(collider_id, new AABB(x, y, SIZE, SIZE));
  }
  
  void draw() {   
    imageMode(CENTER);
    image(actual_image, x, y, SIZE, SIZE);
  }
}
