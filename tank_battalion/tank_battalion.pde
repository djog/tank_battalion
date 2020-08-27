// Consts
final String SPRITES_FOLDER = "../assets/sprites/";
final String FONTS_FOLDER = "../assets/fonts/";
final int ARENA_X = 233;
final int ARENA_Y = 32;
final int ARENA_SIZE = 836;
final int ARENA_CENTER_X = ARENA_X + ARENA_SIZE / 2;
final int ARENA_CENTER_Y = ARENA_Y + ARENA_SIZE / 2;

int high_score = 0;
int score = 0;

// Images
PImage background_image;
PImage tank_image;
PFont game_font;

float tank_x;
float tank_y;

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
}

void draw() {
  background(0);
  
  rectMode(CORNER);
  image(background_image, 0, 0, width, height);
  
  rectMode(CENTER);
  image(tank_image, tank_x, tank_y, 64, 64);
  
  // Draw the Score HUD
  textFont(game_font);
  textSize(24);
  textAlign(CENTER,CENTER);
  fill(255, 0, 0);
  text("HIGH",width - 350, 50); 
  text("SCORE",width - 350, 75);
  fill(255);
  text(high_score,width - 350,100);
  
  fill(255,0,0);
  text("SCORE", width - 350, 150);
  fill(255);
  text(score, width - 350, 175);
}
