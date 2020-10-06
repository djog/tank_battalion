// Globals
StateManager state_manager;
PhysicsManager physics_manager = new PhysicsManager();

// Some consts
static final String SPRITES_FOLDER = "../assets/sprites/";
static final String FONTS_FOLDER = "../assets/fonts/";
static final String LEVEL_FOLDER = "../assets/levels/";

void setup() {
  // P2D - Might not work on Linux
  // Comment the 2 lines below if you're NOT using P2D renderer
  size(1600, 887, P2D);
  ((PGraphicsOpenGL)g).textureSampling(2);
  // No P2D - Uncomment the line below if you're NOT using P2D renderer
  // size(1600, 887);
  
  // Settings  
  frameRate(60); // Just 60 for now
  smooth(0); // For the pixelart & retro effect
  
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
