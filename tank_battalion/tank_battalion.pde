// Consts
final String SPRITES_FOLDER = "../assets/sprites/";

// Images
PImage background_image;
PImage tank_image;

float tank_x;
float tank_y;

void setup() {
  // Settings  
  fullScreen();
  frameRate(60);
  
  // Load files
  background_image = loadImage(SPRITES_FOLDER + "Background.png");
  tank_image = loadImage(SPRITES_FOLDER + "PlayerUp.png");
  
  // Center the tank
  tank_x = width /2;
  tank_y = height /2;
}


void draw() {
  background(0);
  
  rectMode(CORNER);
  image(background_image, 0, 0, width, height);
  rectMode(CENTER);
  image(tank_image, tank_x, tank_y, 64, 64);
}
