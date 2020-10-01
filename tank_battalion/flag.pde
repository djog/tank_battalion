class Flag {
static final int size = 64;

  int x, y;
  
  
  PImage flag;
  
  Flag(int xpos, int ypos)
  {
   x = xpos;
   y = ypos;
   
    flag = loadImage(SPRITES_FOLDER + "Flag.png");
  }
  
   void draw() {   
    imageMode(CENTER);
    image(flag, x, y, size, size);
  }
}
