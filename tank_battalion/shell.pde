class Shell{
  static final int SIZE = 12;
  int x, y;
  int move_speed = 12;
  PImage shell_sprite;
  boolean up, down, left, right = false;
  int collider_id;
  ArrayList<AABB> collided_objects = null;
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
  
  void set_collided_objects(ArrayList<AABB> object){
    collided_objects = object;
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
    if (physics_manager.check_collision(x, y, SIZE, SIZE, collider_id, this))
    {
      for(AABB object : collided_objects){
        PVector point = screen_to_grid_coords(object.x1, object.y1);
        if(point.x >= 0 && point.y >= 0){
          grid.nodes[int(point.x)][int(point.y)] = 0;
          physics_manager.remove_collider(object);
        }
      }
      collided_objects = null;
      physics_manager.remove_collider(collider_id);
      remove = true;
    }
    if(!remove){
      physics_manager.update_collider(collider_id, new AABB(x, y, SIZE, SIZE));
    }
  }
  
  void draw() { 
    image(shell_sprite, x, y, SIZE, SIZE);
  }
}
