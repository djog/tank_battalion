class Shell{
  static final int SIZE = 12;
  int x, y;
  int move_speed = 12;
  PImage shell_sprite;
  boolean up, down, left, right = false;
  int collider_id;
  boolean remove = false;
  
  public Shell(int tx, int ty, int direction){
    x = tx;
    y = ty;
    if(direction == 1){
      up = true;
      y -= Player.SIZE / 2;
    }
    else if(direction == 2){
      down = true;
      y += Player.SIZE / 2;
    }
    else if(direction == 3){
      left = true;
      x -= Player.SIZE / 2;
    }
    else if(direction == 4){ 
      right = true;
      x += Player.SIZE / 2;
    }
    shell_sprite = loadImage(SPRITES_FOLDER + "Shell.png");
    collider_id = physics_manager.get_collider_id();
  }
  
  void update(Grid grid) {
    if(up){
      y -= move_speed;
    }
    else if(down){
      y += move_speed;
    }
    else if(left){
      x -= move_speed;
    }
    else if(right){
      x += move_speed;
    }
    if (physics_manager.check_collision(x, y, SIZE, SIZE, collider_id, true, grid))
    {
      physics_manager.remove_collider(collider_id);
      remove = true;
    }
    if(!remove){
      physics_manager.update_collider(collider_id, new AABB(x, y, SIZE, SIZE, ColliderType.SHELL));
    }
  }
  
  void draw() { 
    image(shell_sprite, x, y, SIZE, SIZE);
  }
}
