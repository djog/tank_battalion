// Game state consts
static final int ARENA_X = 233;
static final int ARENA_Y = 27;
static final int ARENA_BORDER = 32;
static final int ARENA_SIZE = 836;
static final int ARENA_CENTER_X = ARENA_X + ARENA_SIZE / 2;
static final int ARENA_CENTER_Y = ARENA_Y + ARENA_SIZE / 2;
static final float MIN_SPAWN_DEALY = 3.0f;
static final float MAX_SPAWN_DEALY = 6.0f;

class GameState extends State
{
  boolean debug_collision = false;

  int high_score = 0;
  int score = 0;
  int round = 0;

  PImage background_image;
  PFont game_font;
     
  Grid grid;
  Player player;
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();

  float enemy_spawn_timer = random(MIN_SPAWN_DEALY, MAX_SPAWN_DEALY);


  void on_start() {
    // Load files
    background_image = loadImage(SPRITES_FOLDER + "Background.png");
    game_font = createFont(FONTS_FOLDER + "RetroGaming.ttf", 48.0);

    // Initialize grid
    grid = new Grid();
    player = new Player(ARENA_X + 40, ARENA_Y + 43 * Grid.NODE_SIZE_Y);   
  }

  void on_input(boolean is_key_down) {
    player.input(keyCode, is_key_down);

    if (keyCode == 'P' || keyCode == 'p')
    {
      debug_collision = is_key_down;
    }
    if (is_key_down)
    {
      if (keyCode == '.' && round > 1)
      {
          round --;
      }
      else if (keyCode == '/' &&  round < 99)
      {
          round ++;
      }
    }    
  }

  void on_update(float delta_time)
  {
    // Maybe spawn some new enemies
    spawn_enemies(delta_time);

    // Update enemies
    for(Enemy enemy: enemies){
      enemy.update(delta_time);
    }

    // Update player
    player.update();
  }
  
  void spawn_enemies(float delta_time)
  {
    // Spawn an enemy if timer is over
    enemy_spawn_timer -= delta_time;
    if(enemy_spawn_timer < 0) {
      // Check all possible locations for an enemy to spawn
      int step_size = Enemy.SIZE / 8;
      ArrayList<PVector> possibilities = new ArrayList<PVector>();
      for(int x = ARENA_X; x < ARENA_X + ARENA_SIZE; x += step_size)  {
        int test_x = x;
        int test_y = ARENA_Y + ARENA_BORDER + 10;
        if (!physics_manager.check_collision(test_x, test_y, Enemy.SIZE, Enemy.SIZE, -1)) {
          possibilities.add(new PVector(test_x, test_y));
        }
      }
      if (possibilities.size() >= 0)
      { 
        // Pick a random possibility
        int random_index = floor(random(0, possibilities.size() - 1));
        PVector spawn_pos = possibilities.get(random_index);
      
        // Spawn a new enemy
        enemy_spawn_timer = random(MIN_SPAWN_DEALY, MAX_SPAWN_DEALY);
        enemies.add(new Enemy((int)spawn_pos.x, (int)spawn_pos.y));
      }
      else
      {
        println("ERROR: There is not enough room to spawn a new tank! A new one will be spawned when there's enough space.");
      }
    }
  }

  void on_draw()
  {
    background(0);
    
    // Draw background
    imageMode(CORNER);
    image(background_image, 0, 0, width, height);
    
    // Draw the grid
    grid.draw();
    
    // Draw enemies
    for(Enemy enemy: enemies){
      enemy.draw();
    }

    // Draw the player
    player.draw();
    
    // Draw the HUD
    draw_hud();
  }

  // Draw the HUD - Heads up display
  void draw_hud() {
    // Draw text settings
    textFont(game_font);
    textSize(24);
    textAlign(LEFT,CENTER);
    
    // Draw the highscore
    fill(255, 0, 0);
    text("HIGH-",width - 350, 50); 
    text("SCORE",width - 350, 75);
    fill(255);
    text(high_score,width - 350,100);
    
    // Draw the score
    fill(255,0,0);
    text("SCORE", width - 350, 150);
    fill(255);
    text(score, width - 350, 175);

    // Draw the Round
    fill(255, 255, 255);
    text("ROUND " + round,width - 300, 750);
  }
}
