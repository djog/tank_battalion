class Flag {
  static final int SIZE = 64;

  int x, y;

  PImage flag;

  Flag(int xpos, int ypos)
  {
    x = xpos;
    y = ypos;

    flag = loadImage(SPRITES_FOLDER + "Flag.png");
  }

  void update() 
  {
    if (physics_manager.check_collision(x, y, SIZE, SIZE, -1, byte(PLAYER_LAYER | ENEMY_LAYER)))
    { 
      state_manager.switch_state(StateType.GAME_OVER);
    }
  }

  void draw() {   
    imageMode(CENTER);
    image(flag, x, y, SIZE, SIZE);
  }
}
