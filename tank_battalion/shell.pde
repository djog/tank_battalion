class Shell{
  static final int SIZE = 12;
  int x, y;
  PImage shell_sprite;
  
  public Shell(int tx, int ty){
    x = tx;
    y = ty;
    shell_sprite = loadImage(SPRITES_FOLDER + "Shell.png");
  }
  
  void draw() {   
    image(shell_sprite, x, y, SIZE, SIZE);
  }
}
