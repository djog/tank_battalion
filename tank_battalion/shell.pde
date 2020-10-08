class Shell {
  static final int SIZE = 9;
  int x, y;
  int move_speed = 12;
  PImage shell_sprite;
  boolean up, down, left, right = false;
  int collider_id;
  boolean is_destroyed = false;
  byte layer_mask;
  
  public Shell(int tx, int ty, int direction, byte layer_mask) {
    x = tx;
    y = ty;
    if (direction == 1) {
      up = true;
      y -= Player.SIZE / 2;
    } else if (direction == 2) {
      down = true;
      y += Player.SIZE / 2;
    } else if (direction == 3) {
      left = true;
      x -= Player.SIZE / 2;
    } else if (direction == 4) { 
      right = true;
      x += Player.SIZE / 2;
    }
    shell_sprite = loadImage(SPRITES_FOLDER + "Shell.png");
    collider_id = physics_manager.get_collider_id();
    this.layer_mask = layer_mask;
  }

  void update() {
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
      is_destroyed = true;
      physics_manager.remove_colliding_grid_nodes(x, y, Grid.NODE_SIZE, Grid.NODE_SIZE);
      physics_manager.remove_collider(collider_id);
    }
    else
    {
      physics_manager.update_collider(collider_id, new AABB(x, y, SIZE, SIZE, layer_mask));
    }
  }

  void draw() {   
    imageMode(CENTER);
    image(shell_sprite, x, y, SIZE, SIZE);
  }
}
