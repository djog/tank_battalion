class Enemy {
  static final int SIZE = 52;
  static final float MIN_ROTATE_DELAY = .2f;
  static final float MAX_ROTATE_DELAY = .8f;
  static final float MIN_FIRE_DELAY = 1.0f;
  static final float MAX_FIRE_DELAY = 3.0f;
  
  static final byte SHELL_LAYER_MASK = (DEFAULT_LAYER | ENVIRONMENT_LAYER | PLAYER_LAYER);

  public boolean is_dead = false;

  int x, y;
  int move_speed = 3;
  int collider_id;
  float rotate_timer = 0.0f;
  float rotate_delay = 0.0f;
  float fire_timer = 0.0f;
  float fire_delay = 0.0f;
  int target_direction;
  int direction = 1;
  boolean is_rainbow;
  color tint = color(255, 0, 0);
  float tint_cooldown = 0.2f;
  color color_blue = color(0, 0, 255);
  color color_red = color(255, 0, 0);
  
  PImage enemy_up, enemy_down, enemy_left, enemy_right, actual_image;

  Enemy(int xpos, int ypos, boolean is_rainbow) {
    x = xpos;
    y = ypos;
    this.is_rainbow = is_rainbow; 
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
    tint_cooldown -= deltaTime;
    
    be_smart();
    
    if (rotate_timer > rotate_delay)
    {
      direction = target_direction;
      rotate_timer = 0.0f;
      rotate_delay = random(MIN_ROTATE_DELAY, MAX_ROTATE_DELAY);
    }
    if (fire_timer > fire_delay) {
      fire_timer = 0.0f;
      fire_delay = random(MIN_FIRE_DELAY, MAX_ROTATE_DELAY);
      shells.add(new Shell(x, y, direction, SHELL_LAYER_MASK));
    }

    if (tint_cooldown < 0) {
      if (tint == color_blue) {
        tint = color_red;
      } else {
        tint = color_blue;
      }
      tint_cooldown = 0.2f;
    }

    if (direction == 0) {
      actual_image = enemy_up;
      target_y -= move_speed;
    } else if (direction == 1) {
      actual_image = enemy_down;
      target_y += move_speed;
    } else if (direction == 2) {
      actual_image = enemy_left;
      target_x -= move_speed;
    } else if (direction == 3) {
      actual_image = enemy_right;
      target_x += move_speed;
    }
    if (!physics_manager.check_collision(target_x, target_y, SIZE, SIZE, collider_id, ALL_LAYERS))
    {
      x = target_x;
      y = target_y;
    }
    physics_manager.update_collider(collider_id, new AABB(x, y, SIZE, SIZE, ENEMY_LAYER, ColliderParentType.ENEMY, this));
  }
  
  void be_smart()
  {
    target_direction = int(random(0, 4));
  }
  
  void draw() {   
    imageMode(CENTER);
    if (is_rainbow == true) {
      tint(tint, 255);
    }
    image(actual_image, x, y, SIZE, SIZE);
    tint(255, 255, 255, 255);
  }

  public void die() {
    audio_manager.play_sound("explosion.wav"); 
    physics_manager.remove_collider(collider_id);
    is_dead = true;
  }
}
