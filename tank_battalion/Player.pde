class Player {
  int x;
  int y;
  
  final String SPRITES_FOLDER = "../assets/sprites/";
  
  PImage player_up;
  
  Player(int xpos, int ypos) {
    x = xpos;
    y = ypos;
    player_up = loadImage(SPRITES_FOLDER + "PlayerUp.png");
  }
  
  void keyPressed(){
    if(key == UP){
      y += 1;
    }
  }
  
  void draw() {
    rectMode(CENTER);
    image(player_up, x, y, 64, 64);
  }
}
