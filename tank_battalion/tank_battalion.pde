// Consts
final String SPRITES_FOLDER = "../assets/sprites/";

// Images
PImage background_image;
PImage tank_image;


float scale;

float tank_x;
float tank_y;

void setup() {
  // Settings  
  fullScreen();
  frameRate(60);
  
  // Load files
  background_image = loadImage(SPRITES_FOLDER + "Background.png");
  tank_image = loadImage(SPRITES_FOLDER + "PlayerUp.png");
  
  scale = height / background_image.height;
  tank_x = width /2;
  tank_y = height /2;
}

void draw() {
  background(0);
  image(background_image, scale * background_image.width / 4, 0, scale * background_image.width, height);
  image(tank_image, tank_x, tank_y, tank_image.width * scale, tank_image.height * scale);
}
