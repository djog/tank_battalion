// Globals
StateManager state_manager;
PhysicsManager physics_manager = new PhysicsManager();
AudioManager audio_manager = new AudioManager(this);

// Some consts
static final String SPRITES_FOLDER = "../assets/sprites/";
static final String SOUNDS_FOLDER = "../assets/audio/";
static final String FONTS_FOLDER = "../assets/fonts/";
static final String LEVEL_FOLDER = "../assets/levels/";
static final int WINDOW_WIDTH = 1600;
static final int WINDOW_HEIGHT = 896;

static final String OPERATING_SYSTEM = System.getProperty("os.name");

void settings()
{
  println("Running on: " + OPERATING_SYSTEM);
  if (OPERATING_SYSTEM.contains("linux"))
  {
    println("Using PD2 renderer.");
    size(WINDOW_WIDTH, WINDOW_HEIGHT, P2D);
    ((PGraphicsOpenGL)g).textureSampling(2);
  }
  else
  {
    println("Using legacy renderer.");
    size(WINDOW_WIDTH, WINDOW_HEIGHT);  
  }
  
  

  smooth(0); // For the pixelart & retro effect
}

void setup() {
    frameRate(60); // Just 60 for now
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
