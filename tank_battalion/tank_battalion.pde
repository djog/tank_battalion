// Consts
final String SPRITES_FOLDER = "../assets/sprites/";
final String FONTS_FOLDER = "../assets/fonts/";
final int ARENA_X = 233;
final int ARENA_Y = 32;
final int ARENA_SIZE = 836;
final int ARENA_CENTER_X = ARENA_X + ARENA_SIZE / 2;
final int ARENA_CENTER_Y = ARENA_Y + ARENA_SIZE / 2;

// Images
PImage background_image;
PImage tank_image;
PFont game_font;

float tank_x;
float tank_y;

Grid grid;
  
void setup() {
  // Settings  
  size(1600, 900);
  frameRate(60);
  
  // For the pixelart & retro effect
  smooth(0);
  
  // Load files
  background_image = loadImage(SPRITES_FOLDER + "Background.png");
  tank_image = loadImage(SPRITES_FOLDER + "PlayerUp.png");
  game_font = createFont(FONTS_FOLDER + "RetroGaming.ttf", 48.0);
  
  // Center the tank
  tank_x = ARENA_CENTER_X;
  tank_y = ARENA_CENTER_Y;
  
  // Initialize grid
  grid = new Grid();
}  

void draw() {
  background(0);
  
  // Draw brackground
  rectMode(CORNER);
  image(background_image, 0, 0, width, height);
  
  // Draw the grid
  grid.draw();
  
  // Draw tank/player
  rectMode(CENTER);
  image(tank_image, tank_x, tank_y, 64, 64);
}
