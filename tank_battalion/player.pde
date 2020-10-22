class Player {
  static final int SIZE = 52;
  static final int SPACE = 32;
  static final float FIRE_COOLDOWN = 0.3f;

  static final byte SHELL_LAYER_MASK = (DEFAULT_LAYER | ENVIRONMENT_LAYER | ENEMY_LAYER);

  int x, y;
  int move_speed = 4;
  int collider_id;
  float cooldown = FIRE_COOLDOWN;
  int direction = 1;

  boolean up, down, left, right, fire = false;
  boolean is_dead;

  PImage player_up, player_down, player_left, player_right, tank_image;

  Player(int xpos, int ypos) {
    x = xpos;
    y = ypos;
    collider_id = physics_manager.get_collider_id();
    player_up = loadImage(SPRITES_FOLDER + "PlayerUp.png");
    player_down = loadImage(SPRITES_FOLDER + "PlayerDown.png");
    player_left = loadImage(SPRITES_FOLDER + "PlayerLeft.png");
    player_right = loadImage(SPRITES_FOLDER + "PlayerRight.png");
    tank_image = player_up;
  }

  void input(int k, boolean value) {
    switch(k) {
    case SPACE:
      if (cooldown < 0.0f) {         
        fire = true;
      }
      break;

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

  void update(ArrayList<Shell> shells, float delta_time) {
    int target_x = x;
    int target_y = y;
    cooldown -= delta_time;

    if (up) {
      tank_image = player_up;
      target_y -= move_speed;
      direction = 0;
    } else if (down) {
      tank_image = player_down;
      target_y += move_speed;
      direction = 1;
    } else if (left) {
      tank_image = player_left;
      target_x -= move_speed;
      direction = 2;
    } else if (right) {
      tank_image = player_right;
      target_x += move_speed;
      direction = 3;
    }
    if (up || down || left || right)
    {
      audio_manager.play_sound("driving.wav");
    }
    else
    {
      audio_manager.stop_sound("driving.wav");
    }
    if (fire) {
      // Fire a shell
      shells.add(new Shell(x, y, direction, SHELL_LAYER_MASK));
      audio_manager.play_sound("shoot.wav"); 
      cooldown = FIRE_COOLDOWN;
      fire = false;
    }
    // Only move the player if the target position does not hit an obstacle
    if (!physics_manager.check_collision(target_x, target_y, SIZE, SIZE, collider_id, ALL_LAYERS))
    {
      x = target_x;
      y = target_y;
    }
    physics_manager.update_collider(collider_id, new AABB(x, y, SIZE, SIZE, PLAYER_LAYER, ColliderParentType.PLAYER, this));
  }

  void draw() {   
    imageMode(CENTER);
    image(tank_image, x, y, SIZE, SIZE);
  }

  public void die()
  {
    audio_manager.play_sound("explosion.wav"); 
    is_dead = true;
    physics_manager.remove_collider(collider_id);
  }
}
