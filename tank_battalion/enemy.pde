class Enemy {
  static final int SIZE = 64;
  static final float MIN_ROTATE_DELAY = .2f;
  static final float MAX_ROTATE_DELAY = .5f;
  static final float MIN_FIRE_DELAY = 1.0f;
  static final float MAX_FIRE_DELAY = 3.0f;
  
  public boolean is_dead = true;
  
  int x, y;
  int move_speed = 3;
  int collider_id;
  float rotate_timer = 0.0f;
  float rotate_delay = 0.0f;
  float fire_timer = 0.0f;
  float fire_delay = 0.0f;
  int direction = 1;

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
  
  void update(ArrayList<Shell> shells, float deltaTime) {
    int target_x = x;
    int target_y = y;
    rotate_timer += deltaTime;
    fire_timer += deltaTime;
    if (rotate_timer > rotate_delay)
    {
      direction = int(random(1, 5));
      rotate_timer = 0.0f;
      rotate_delay = random(MIN_ROTATE_DELAY, MAX_ROTATE_DELAY);
    }
    if(fire_timer > fire_delay){
      fire_timer = 0.0f;
      fire_delay = random(MIN_FIRE_DELAY, MAX_ROTATE_DELAY);
      shells.add(new Shell(x, y, direction));
    }
    
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
  
  public void die() {
    physics_manager.remove_collider(collider_id);
    is_dead = true;
  }
}
