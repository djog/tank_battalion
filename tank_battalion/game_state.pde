import java.util.Iterator;

// Game state consts
static final int ARENA_BORDER = 32;
static final int ARENA_X = 200 + ARENA_BORDER;
static final int ARENA_Y = ARENA_BORDER;
static final int ARENA_SIZE = WINDOW_HEIGHT - 2*ARENA_BORDER;
static final int ARENA_CENTER_X = ARENA_X + ARENA_SIZE / 2;
static final int ARENA_CENTER_Y = ARENA_Y + ARENA_SIZE / 2;
static final float MIN_SPAWN_DEALY = 3.0f;
static final float MAX_SPAWN_DEALY = 6.0f;
static final int LIVES_PER_ROUND = 3;

class GameState extends State
{
  int round = 1;
  int n_lives = LIVES_PER_ROUND;
  int opponents_left = 0;

  PImage background_image;
  PImage tank_image;
  PImage enemy_image;
  PFont game_font;

  Grid grid;
  Player player;
  Flag flag;
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  ArrayList<Shell> shells = new ArrayList<Shell>();

  float enemy_spawn_timer = random(MIN_SPAWN_DEALY, MAX_SPAWN_DEALY);

  @Override
    void on_start() {
    // Load files
    background_image = loadImage(SPRITES_FOLDER + "Background.png");
    tank_image = loadImage(SPRITES_FOLDER + "PlayerUp.png");
    enemy_image = loadImage(SPRITES_FOLDER + "EnemyUp.png");
    game_font = createFont(FONTS_FOLDER + "RetroGaming.ttf", 48.0);
    game_data.reset_score();
    
    setup_round();
  }

  // Setup the round according the the round variable
  void setup_round() {
    opponents_left = 4 + round * 3;
    n_lives = LIVES_PER_ROUND;
    grid = new Grid(round);
    spawn_player();
    flag = new Flag(ARENA_CENTER_X + Flag.SIZE/2, ARENA_Y + ARENA_SIZE - Flag.SIZE + Flag.SIZE/2);
    enemies.clear();
    physics_manager.cleanup();
  }

  @Override
    void on_input(boolean is_key_down) {
    player.input(keyCode, is_key_down);

    if (is_key_down)
    {
      if (keyCode == 'B' && ENABLE_EASTER_EGGS) {
       audio_manager.play_sound("bruh.mp3"); 
      }
      if (keyCode == DELETE || keyCode == 'K' && ENABLE_DEBUG_MODE)
      {
        // kill all enemies - for debugging purposses
        while (enemies.size() > 0)
        {
          enemies.get(0).die();
          enemies.remove(0); 
          game_data.add_score(10);
          opponents_left--;
        }
      }
      // Toggle physics debug mode
      if ((keyCode == 'P' || keyCode == 'p') && ENABLE_DEBUG_MODE)
      {
        physics_manager.is_debugging = !physics_manager.is_debugging;
      }
      if ((keyCode == 'I' || keyCode == 'i') && ENABLE_DEBUG_MODE)
      {
        spawn_enemy();
      }
    }
  }

  @Override
    void on_update(float delta_time)
  {
    // Maybe spawn some new enemies
    if (opponents_left - enemies.size() > 0)
      spawn_enemies(delta_time);

    if (opponents_left <= 0 && enemies.size() == 0)
    {
      round++;
      setup_round();
    }
    
    // Update enemies
    for(Iterator<Enemy> iterator = enemies.iterator(); iterator.hasNext();){
      Enemy enemy = iterator.next();
      if(enemy.is_dead){
        game_data.add_score(int(random(30, 1601)));
        opponents_left--;
        iterator.remove();
        continue;
      }
      enemy.update(shells, delta_time);
    }

    for(Iterator<Shell> iterator = shells.iterator(); iterator.hasNext();){
      Shell shell = iterator.next();
      shell.update(enemies);
      if(shell.is_destroyed){
        iterator.remove();
      }
    }

    // Update player
    if (player.is_dead)
    {
      if (n_lives > 0)
      {
        // Repsawn player
        spawn_player();
        n_lives--;
      }
      else
      {
        state_manager.switch_state(StateType.GAME_OVER);  
      }
    }
    else
    {
      player.update(shells, delta_time);
    }
    
    // Update flag
    flag.update();
  }
  
  void spawn_player()
  {
    player = new Player(ARENA_X + Player.SIZE, ARENA_Y + ARENA_SIZE - Player.SIZE);
  }
  
  void spawn_enemies(float delta_time)
  {
    // Spawn an enemy if timer is over
    enemy_spawn_timer -= delta_time;
    if (enemy_spawn_timer < 0) {
      spawn_enemy();
    }
  }

  void spawn_enemy()
  {
    // Check all possible locations for an enemy to spawn
    int step_size = Enemy.SIZE / 8;
    ArrayList<PVector> possibilities = new ArrayList<PVector>();
    for (int x = ARENA_X; x < ARENA_X + ARENA_SIZE; x += step_size) {
      int test_x = x;
      int test_y = ARENA_Y + ARENA_BORDER + 10;
      if (!physics_manager.check_collision(test_x, test_y, Enemy.SIZE, Enemy.SIZE, -1, ALL_LAYERS)) {
        possibilities.add(new PVector(test_x, test_y));
      }
    }
    if (possibilities.size() > 0)
    { 
      // Pick a random possibility
      int random_index = floor(random(0, possibilities.size() - 1));
      PVector spawn_pos = possibilities.get(random_index);

      // Spawn a new enemy
      enemy_spawn_timer = random(MIN_SPAWN_DEALY, MAX_SPAWN_DEALY);
      int rainbow_chance =(int)random(0, 100);
      boolean is_rainbow = false;
      if (rainbow_chance <= 20) { // 20 % change to be a rainbow tank for now
        is_rainbow=true;
      }
      enemies.add(new Enemy((int)spawn_pos.x, (int)spawn_pos.y, is_rainbow));
    } else
    {
      println("ERROR: There is not enough room to spawn a new tank!");
    }
  }

  @Override
    void on_draw()
  {
    background(#060606);

    // Draw background
    imageMode(CORNER);
    image(background_image, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);

    // Draw the grid
    grid.draw();

    // Draw enemies
    for (Enemy enemy : enemies) {
      enemy.draw();
    }

    // Flag draw
    flag.draw();

    for (Shell shell : shells) {
      shell.draw();
    }

    // Draw the player
    player.draw();

    physics_manager.draw_debug();

    // Draw the HUD
    draw_hud();
  }

  // Draw the HUD - Heads up display
  void draw_hud() {
    // Draw text settings
    textFont(game_font);
    textSize(24);
    textAlign(LEFT, CENTER);

    // Draw the highscore
    fill(255, 0, 0);
    text("HIGH-", width - 350, 50); 
    text("SCORE", width - 350, 75);
    fill(255);
    text(game_data.high_score, width - 350, 100);

    // Draw the score
    fill(255, 0, 0);
    text("SCORE", width - 350, 150);
    fill(255);
    text(game_data.score, width - 350, 175);

    // Draw the Round
    fill(255, 255, 255);
    text("ROUND " + round, width - 300, 750);

    // Draw the lives left
    for (int i = 0; i < n_lives; i++)
    {
      image(tank_image, width - 340 + i * (Player.SIZE + 10), 600, Player.SIZE, Player.SIZE);
    }

    //Draw enemies left
    int x = 0;
    int y = 0;
    for (int j = 0; j < opponents_left; j++)
    {
      if (x == 4)
      {
        y++;
        x = 0;
      }
      image(enemy_image, width - 340 + x * (Enemy.SIZE + 10), 400 + y * (Enemy.SIZE + 10), Enemy.SIZE / 1.5, Enemy.SIZE / 1.5);
      x++;
    }
  }
}
