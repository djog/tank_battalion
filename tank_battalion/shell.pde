class Shell {
  static final int SIZE = 9;
  int x, y;
  int move_speed;
  PImage shell_sprite;
  boolean up, down, left, right = false;
  int collider_id;
  boolean is_destroyed = false;
  byte layer_mask;

  public Shell(int tx, int ty, int direction, int move_speed, byte layer_mask) {
    x = tx;
    y = ty;
    this.move_speed = move_speed;
    if (direction == 0) {
      up = true;
      y -= Player.SIZE / 2;
    } else if (direction == 1) {
      down = true;
      y += Player.SIZE / 2;
    } else if (direction == 2) {
      left = true;
      x -= Player.SIZE / 2;
    } else if (direction == 3) { 
      right = true;
      x += Player.SIZE / 2;
    }
    shell_sprite = loadImage(SPRITES_FOLDER + "Shell.png");
    collider_id = physics_manager.get_collider_id();
    this.layer_mask = layer_mask;
  }

  void update(ArrayList<Enemy> enemies) {
    if (is_destroyed) return;
    if (up) {
      y -= move_speed;
    } else if (down) {
      y += move_speed;
    } else if (left) {
      x -= move_speed;
    } else if (right) {
      x += move_speed;
    }

    if (physics_manager.check_collision(x, y, SIZE, SIZE, collider_id, layer_mask))
    {
      ArrayList<AABB> collided_objects = physics_manager.get_collided_objects();
      for (AABB collider : collided_objects) {
        // Damage enemy if collided with an enemy
        if (collider.parent_type == ColliderParentType.ENEMY)
        {
          Enemy enemy = (Enemy)collider.parent;
          enemy.die();
        }
        // Damage player if collided with a player
        if (collider.parent_type == ColliderParentType.PLAYER)
        {
          Player player = (Player)collider.parent;
          player.die();
        }
      }

      is_destroyed = true;
      int size_x = Grid.NODE_SIZE;
      int size_y = Grid.NODE_SIZE;
      if (up || down) {
        size_x = Player.SIZE;
      } else {
        size_y = Player.SIZE;
      }
      physics_manager.remove_colliding_grid_nodes(x, y, size_x, size_y);
      physics_manager.remove_collider(collider_id);
    } else
    {
      physics_manager.update_collider(collider_id, new AABB(x, y, SIZE, SIZE, layer_mask));
    }
  }

  void draw() {   
    imageMode(CENTER);
    image(shell_sprite, x, y, SIZE, SIZE);
  }
}
