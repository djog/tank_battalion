// Globals
StateManager state_manager;
PhysicsManager physics_manager = new PhysicsManager();
AudioManager audio_manager = new AudioManager(this);
GameData game_data = new GameData();

// Game settings
static final boolean ENABLE_EASTER_EGGS = true;
static final boolean ENABLE_DEBUG_MODE = false;

// Some consts
static final String SPRITES_FOLDER = "../assets/sprites/";
static final String SOUNDS_FOLDER = "../assets/audio/";
static final String FONTS_FOLDER = "../assets/fonts/";
static final String LEVEL_FOLDER = "../assets/levels/";
static final int WINDOW_WIDTH = 1600;
static final int WINDOW_HEIGHT = 896;

static final String OPERATING_SYSTEM = System.getProperty("os.name").toLowerCase();

void settings()
{
  if (ENABLE_DEBUG_MODE) println("Running on: " + OPERATING_SYSTEM);
  if (!OPERATING_SYSTEM.contains("linux"))
  {
    if (ENABLE_DEBUG_MODE) println("Using PD2 renderer.");
    size(WINDOW_WIDTH, WINDOW_HEIGHT, P2D);

  }
  else
  {
    if (ENABLE_DEBUG_MODE) println("Using legacy renderer.");
    size(WINDOW_WIDTH, WINDOW_HEIGHT);  
  }
  
  smooth(0); // For the pixelart & retro effect
}

void setup() {
  frameRate(60); // Just 60 for 
  if (!OPERATING_SYSTEM.contains("linux"))
  {
    ((PGraphicsOpenGL)g).textureSampling(2);
  }
  
  state_manager = new StateManager();
}

void keyPressed() {
  state_manager.handle_input(true);
}

void keyReleased() {
  state_manager.handle_input(false);
}

void draw() {
  state_manager.update_frame();
}
