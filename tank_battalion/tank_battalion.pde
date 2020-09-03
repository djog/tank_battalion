// Consts
static final String SPRITES_FOLDER = "../assets/sprites/";
static final String FONTS_FOLDER = "../assets/fonts/";
static final int ARENA_X = 233;
static final int ARENA_Y = 32;
static final int ARENA_SIZE = 836;
static final int ARENA_CENTER_X = ARENA_X + ARENA_SIZE / 2;
static final int ARENA_CENTER_Y = ARENA_Y + ARENA_SIZE / 2;

boolean debug_collision = false;

int high_score = 0;
int score = 0;

float x;
float y;

// Images
PImage background_image;
PImage Flag_image;
PFont game_font;

Grid grid;
Player player;
Enemy[] enemies;

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
  Flag_image = loadImage(SPRITES_FOLDER + "Flag.png");
  game_font = createFont(FONTS_FOLDER + "RetroGaming.ttf", 48.0);

  // Initialize grid
  grid = new Grid();
  player = new Player(ARENA_CENTER_X, ARENA_CENTER_Y);
  enemies = new Enemy[10];
  for(int i = 0; i < 10; i++){
    enemies[i] = new Enemy(ARENA_CENTER_X + 64 * i, ARENA_CENTER_Y + 64 * i);
  }
}

void keyPressed() {
  player.input(keyCode, true);
  if (keyCode == 'P' || keyCode == 'p')
  {
    debug_collision = true;
  }
}

void keyReleased() {
  player.input(keyCode, false);
  if (keyCode == 'P' || keyCode == 'p')
  {
    debug_collision = false;
  }
}

void draw() {
  background(0);
  
  // Draw brackground
  imageMode(CORNER);
  image(background_image, 0, 0, width, height);
  rectMode(CENTER);
  image(Flag_image, 620, 760, 64, 64);
  
  // Draw the grid
  grid.draw();
  
  // Update & draw the player
  player.update(grid.get_nodes());
  player.draw();
  
  for(Enemy enemy: enemies){
    enemy.update(grid.get_nodes());
    enemy.draw();
  }
  
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
