// Consts
static final String SPRITES_FOLDER = "../assets/sprites/";
static final String FONTS_FOLDER = "../assets/fonts/";
static final String LEVEL_FOLDER = "../assets/levels/";
static final int ARENA_X = 233;
static final int ARENA_Y = 27;
static final int ARENA_BORDER = 32;
static final int ARENA_SIZE = 836;
static final int ARENA_CENTER_X = ARENA_X + ARENA_SIZE / 2;
static final int ARENA_CENTER_Y = ARENA_Y + ARENA_SIZE / 2;
static final float MIN_SPAWN_DEALY = 3.0f;
static final float MAX_SPAWN_DEALY = 6.0f;

boolean debug_collision = false;

int high_score = 0;
int score = 0;

// Images
PImage background_image;
PFont game_font;

Grid grid;
Player player;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
PhysicsManager physics_manager = new PhysicsManager();

float enemy_spawn_timer = random(MIN_SPAWN_DEALY, MAX_SPAWN_DEALY);

float previous_time;

void setup() {
  // Settings  
  // P2D might not work on Linux
  size(1600, 887, P2D);
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
  player = new Player(ARENA_X + 40, ARENA_Y + 43 * Grid.NODE_SIZE_Y);
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
  
  float delta_time = (millis() - previous_time) / 1000;
  previous_time = millis();
  enemy_spawn_timer -= delta_time;
  
  if(enemy_spawn_timer < 0){
    enemies.add(new Enemy((int)random(ARENA_X, ARENA_X + ARENA_SIZE), (int)random(ARENA_Y, ARENA_Y + ARENA_SIZE)));
    enemy_spawn_timer = random(MIN_SPAWN_DEALY, MAX_SPAWN_DEALY);
  }
  
  // Draw the grid
  grid.draw();
  
  // Update & draw the player
  player.update();
  player.draw();
  
  // update enemies
  for(Enemy enemy: enemies){
    enemy.update();
    enemy.draw();
  }
  
  // Draw the Score HUD
  draw_score();
  
  //Draw background
  imageMode(CORNER);
  image(background_image, 0, 0, width, height);
}


void draw_score() {
  textFont(game_font);
  textSize(24);
  textAlign(CENTER,CENTER);
  fill(255, 0, 0);
  text("HIGH-",width - 350, 50); 
  text("SCORE",width - 350, 75);
  fill(255);
  text(high_score,width - 350,100);
  
  fill(255,0,0);
  text("SCORE", width - 350, 150);
  fill(255);
  text(score, width - 350, 175); 
}
