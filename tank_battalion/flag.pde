class Flag {
  static final int SIZE = 55;

  int x, y, hits, collider_id;

  PImage flag;

  Flag(int xpos, int ypos)
  {
    x = xpos;
    y = ypos;

    flag = loadImage(SPRITES_FOLDER + "Flag.png");
    
    collider_id = physics_manager.get_collider_id();
  }

  void update() 
  {
    if (physics_manager.check_collision(x, y, SIZE, SIZE, collider_id, byte(PLAYER_LAYER | ENEMY_LAYER)))
    { 
      //state_manager.switch_state(StateType.GAME_OVER);
      hits++;
      print("test");
    }
    physics_manager.update_collider(collider_id, new AABB(x, y, SIZE, SIZE, ALL_LAYERS, ColliderParentType.FLAG, this));
  }

  void draw() {   
    imageMode(CENTER);
    if(hits == 0){
      tint(208, 192, 80, 255);
    }
    else{
      tint(255, 115, 115, 255);
    }
    image(flag, x, y, SIZE, SIZE);
    tint(255, 255, 255, 255);
  }
}
