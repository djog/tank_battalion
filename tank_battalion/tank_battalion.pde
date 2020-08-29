// Consts
static final String SPRITES_FOLDER = "../assets/sprites/";
static final String FONTS_FOLDER = "../assets/fonts/";
static final int ARENA_X = 233;
static final int ARENA_Y = 32;
static final int ARENA_SIZE = 836;
static final int ARENA_CENTER_X = ARENA_X + ARENA_SIZE / 2;
static final int ARENA_CENTER_Y = ARENA_Y + ARENA_SIZE / 2;

int high_score = 0;
int score = 0;

// Images
PImage background_image;
PFont game_font;

Grid grid;
Player player;

void setup() {
  // Settings  
  // I'm using P2D because it's much faster than default
  size(1600, 900, P2D);
  frameRate(60);
  
  // For the pixelart & retro effect
  smooth(0);
  
  // Comment if you're NOT using P2D renderer
  ((PGraphicsOpenGL)g).textureSampling(3);
  
  // Load files
  background_image = loadImage(SPRITES_FOLDER + "Background.png");
  game_font = createFont(FONTS_FOLDER + "RetroGaming.ttf", 48.0);

  // Initialize grid
  grid = new Grid();
  player = new Player(ARENA_CENTER_X, ARENA_CENTER_Y);
}

void keyPressed() {
  player.input(keyCode, true);
}

void keyReleased() {
  player.input(keyCode, false);
}

void draw() {
  background(0);
  
  // Draw brackground
  imageMode(CORNER);
  image(background_image, 0, 0, width, height);
  
  // Draw the grid
  grid.draw();
  player.draw();
  
  print(screenToGridCoords(player.x, player.y));

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
