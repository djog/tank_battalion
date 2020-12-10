enum TankType
{
  NORMAL,
  RAINBOW,
  RED
}

class Enemy {
  static final int SIZE = 52;
  static final float MIN_ROTATE_DELAY = .2f;
  static final float MAX_ROTATE_DELAY = .8f;
  static final float MIN_FIRE_DELAY = 2.0f;
  static final float MAX_FIRE_DELAY = 4.0f;

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
  TankType type;
  color tint = color(255, 0, 0);
  float tint_cooldown = 0.2f;
  IntList colors = new IntList();
  int tint_index = 0;

  PImage enemy_up, enemy_down, enemy_left, enemy_right, actual_image;

  Enemy(int xpos, int ypos, TankType type) {
    x = xpos;
    y = ypos;
    
    this.type = type;
    
    if(type == TankType.NORMAL) {
      tint = color(64, 232, 240);
    }
    if (type == TankType.RED) {
      tint = color(250, 60, 20);    
    }
    
    enemy_up = loadImage(SPRITES_FOLDER + "EnemyUp.png");
    enemy_down = loadImage(SPRITES_FOLDER + "EnemyDown.png");
    enemy_left = loadImage(SPRITES_FOLDER + "EnemyLeft.png");
    enemy_right = loadImage(SPRITES_FOLDER + "EnemyRight.png");
    actual_image = enemy_down;
    collider_id = physics_manager.get_collider_id();
    colors.append(color(0, 0, 230));
    colors.append(color(255, 0, 0));
    colors.append(color(255, 235, 0));
    colors.append(color(0, 210, 0));
  }

  void update(ArrayList<Shell> shells, float deltaTime, PVector player_pos, PVector flag_pos) {
    int target_x = x;
    int target_y = y;
    rotate_timer += deltaTime;
    fire_timer += deltaTime;
    tint_cooldown -= deltaTime;

    be_smart(player_pos, flag_pos);

    if (rotate_timer > rotate_delay)
    {
      direction = target_direction;
      rotate_timer = 0.0f;
      rotate_delay = random(MIN_ROTATE_DELAY, MAX_ROTATE_DELAY);
    }
    if (fire_timer > fire_delay) {
      fire_timer = 0.0f;
      fire_delay = random(MIN_FIRE_DELAY, MAX_ROTATE_DELAY);
      int move_speed = type == TankType.RED ? 16 : 6;
      shells.add(new Shell(x, y, direction, move_speed
      , SHELL_LAYER_MASK));
    }

    if (tint_cooldown < 0 && type == TankType.RAINBOW) {
      tint_index = (tint_index + 1) % 4;
      tint = colors.get(tint_index);
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

  int get_primary_direction(PVector vector)
  {
    // Up: 0
    // Down: 1
    // Right: 3
    // Left 2
    if (abs(vector.x) == abs(vector.y))
    {
      // choose random
      int x_or_y = int(random(0, 2));
      if (x_or_y == 0)
      {
        if (vector.x > 0) 
        {
          return 3; // Right
        } else {
          return 2; // Left
        }
      } else
      {
        if (vector.y > 0) 
        {
          return 1; // Down
        } else {
          return 0; // Up
        }
      }
    } else if (abs(vector.x) > abs(vector.y))
    {
      if (vector.x > 0) 
      {
        return 3; // Right
      } else {
        return 2; // Left
      }
    } else if (abs(vector.x) < abs(vector.y))
    {
      if (vector.y > 0) 
      {
        return 1; // Down
      } else {
        return 0; // Up
      }
    } else // Shouldn't occur
    {
      return -1;
    }
  }

  int get_secondary_direction(PVector vector)
  {
    // Up: 0
    // Down: 1
    // Right: 3
    // Left 2
    if (abs(vector.x) == abs(vector.y))
    {
      // choose random
      int x_or_y = int(random(0, 2));
      if (x_or_y == 0)
      {
        if (vector.x > 0) 
        {
          return 3; // Right
        } else {
          return 2; // Left
        }
      } else
      {
        if (vector.y > 0) 
        {
          return 1; // Down
        } else {
          return 0; // Up
        }
      }
    } else if (abs(vector.x) > abs(vector.y))
    {
      if (vector.y > 0) 
      {
        return 1; // Down
      } else {
        return 0; // Up
      }
    } else if (abs(vector.x) < abs(vector.y))
    {
      if (vector.x > 0) 
      {
        return 3; // Right
      } else {
        return 2; // Left
      }
    } else // Shouldn't occur
    {
      return -1;
    }
  }

  void be_smart(PVector player_pos, PVector flag_pos)
  {
    PVector pos = new PVector(x, y);
    PVector player_dir = player_pos.sub(pos);
    PVector flag_dir = flag_pos.sub(pos);

    boolean target_player = false;
    boolean target_flag = false;

    if (player_dir.mag() < flag_dir.mag())
    {
      target_player = true;
    } else {
      target_flag = true;
    }

    boolean go_up = !physics_manager.check_collision(x, y - SIZE/2, SIZE, SIZE, collider_id, ALL_LAYERS);
    boolean go_down = !physics_manager.check_collision(x, y + SIZE/2, SIZE, SIZE, collider_id, ALL_LAYERS);
    boolean go_left = !physics_manager.check_collision(x - SIZE/2, y, SIZE, SIZE, collider_id, ALL_LAYERS);
    boolean go_right = !physics_manager.check_collision(x + SIZE/2, y, SIZE, SIZE, collider_id, ALL_LAYERS);

    ArrayList<Integer> possibilities = new ArrayList<Integer>();

    if (go_up) possibilities.add(0);
    if (go_down)  possibilities.add(1);
    if (go_right) possibilities.add(3);
    if (go_left) possibilities.add(2);
    
    
    int primary_dir = -1;
    int secondary_dir = -1;
    if (target_flag)
    {
      primary_dir = get_primary_direction(flag_dir);
      secondary_dir = get_secondary_direction(flag_dir);
    } else if (target_player)
    {
      primary_dir = get_primary_direction(player_dir);
      secondary_dir = get_secondary_direction(player_dir);
    }
    
    if (game_data.difficulty == Difficulty.IMPOSSIBLE)
    {
      if (possibilities.contains(primary_dir))
      {
        target_direction = primary_dir;
        return;
      } else if (possibilities.contains(secondary_dir))
      {
        target_direction = secondary_dir;
        return;
      }
    } else if (game_data.difficulty == Difficulty.NORMAL)
    {
      if (possibilities.contains(primary_dir) && possibilities.contains(secondary_dir))
      {
        int chance = int(random(0, 2));
        if (chance == 1)
        {
          target_direction = primary_dir;
          return;
        }
        else
        {
          target_direction = secondary_dir;
          return;
        }
      }else if (possibilities.contains(secondary_dir))
      {
        target_direction = secondary_dir;
        return;
      } 
      else if (possibilities.contains(primary_dir))
      {
        target_direction = primary_dir;
        return;
      } 
    }
    

    if (possibilities.size() > 0)
    {
      int random_index = int(random(0, possibilities.size()));
      target_direction = possibilities.get(random_index);
    } else
    {
      target_direction = int(random(0, 4));
    }
  }

  void draw() {   
    imageMode(CENTER);
    tint(tint, 255);
    image(actual_image, x, y, SIZE, SIZE);
    tint(255, 255, 255, 255);
  }

  public void die() {
    audio_manager.play_sound("explosion.wav"); 
    physics_manager.remove_collider(collider_id);
    is_dead = true;
  }
}
