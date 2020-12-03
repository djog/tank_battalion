class Player {
  static final int SIZE = 52;
  static final int SPACE = 32;
  static final float FIRE_COOLDOWN = 0.4f;
  static final float UPGRADED_FIRE_COOLDOWN = 0.2f;
  static final int SHELL_SPEED = 8;
  static final int UPGRADED_SHELL_SPEED = 11;
  
  static final byte SHELL_LAYER_MASK = (DEFAULT_LAYER | ENVIRONMENT_LAYER | ENEMY_LAYER);
  static final int NORMAL_SPEED = 4;
  static final int UPGRADED_SPEED = 5;
  
  boolean is_upgraded = false;
  
  int x, y;
  int move_speed = 4;
  int collider_id;
  float cooldown = FIRE_COOLDOWN;
  int direction = 0;

  boolean up, down, left, right, fire = false;
  boolean is_dead;
  
  PImage player_up, player_down, player_left, player_right, tank_image;
  PImage ug_player_up, ug_player_down, ug_player_left, ug_player_right;
  
  Player(int xpos, int ypos) {
    x = xpos;
    y = ypos;
    collider_id = physics_manager.get_collider_id();
    player_up = loadImage(SPRITES_FOLDER + "PlayerUp.png");
    player_down = loadImage(SPRITES_FOLDER + "PlayerDown.png");
    player_left = loadImage(SPRITES_FOLDER + "PlayerLeft.png");
    player_right = loadImage(SPRITES_FOLDER + "PlayerRight.png");
    ug_player_up = loadImage(SPRITES_FOLDER + "UpgradedPlayerUp.png");
    ug_player_down = loadImage(SPRITES_FOLDER + "UpgradedPlayerDown.png");
    ug_player_left = loadImage(SPRITES_FOLDER + "UpgradedPlayerLeft.png");
    ug_player_right = loadImage(SPRITES_FOLDER + "UpgradedPlayerRight.png");
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
      target_y -= move_speed;
      direction = 0;
    } else if (down) {
      target_y += move_speed;
      direction = 1;
    } else if (left) {
      target_x -= move_speed;
      direction = 2;
    } else if (right) {
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
      int shell_speed;
      if (is_upgraded)
      {
        shell_speed = UPGRADED_SHELL_SPEED;
      } else
      {
        shell_speed = SHELL_SPEED;
      }
      shells.add(new Shell(x, y, direction, shell_speed, SHELL_LAYER_MASK));
      audio_manager.play_sound("shoot.wav"); 
      if (!is_upgraded)
        cooldown = FIRE_COOLDOWN;
      else
        cooldown = UPGRADED_FIRE_COOLDOWN;
        
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
  
  void upgrade()
  {
    this.is_upgraded = true;
    this.move_speed = UPGRADED_SPEED;
    this.tank_image = ug_player_up; // Temp fix: system is infexible
    audio_manager.play_sound("transform.wav");
  }
  
  void draw() {   
     if (!is_upgraded)
    {
      if(up)
      {
        tank_image = player_up;
      } else if (left) {
        tank_image = player_left;
      } else if (right)
      {
        tank_image = player_right;
      } else if (down)
      {
        tank_image = player_down;
      }
    }
    else
    {
      if(up)
      {
        tank_image = ug_player_up;
      } else if (left) {
        tank_image = ug_player_left;
      } else if (right)
      {
        tank_image = ug_player_right;
      } else if (down)
      {
        tank_image = ug_player_down;
      }
    }
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
