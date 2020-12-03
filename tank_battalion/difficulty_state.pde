class DifficultyState extends State
{
  PFont menu_font;
  
  Button easy_button;
  Button normal_button;
  Button impossible_button;
  
  @Override
  void on_start() {
    menu_font = createFont(FONTS_FOLDER + "RetroGaming.ttf", 128.0);
    final int BUTTONS_OFFSET = 140;
    final int BUTTONS_SPACING = 40;
    easy_button = new Button(width / 2, height /2 + BUTTONS_OFFSET, "EASY");
    normal_button = new Button(width / 2, height /2 + BUTTONS_OFFSET + Button.HEIGHT + BUTTONS_SPACING, "NORMAL");
    impossible_button = new Button(width / 2, height /2 + BUTTONS_OFFSET + 2*Button.HEIGHT + 2*BUTTONS_SPACING, "IMPOSSIBLE");
  }
  
  @Override
  void on_update(float delta_time) {
    easy_button.update();
    normal_button.update();
    impossible_button.update();
    
    if (easy_button.is_pressed()) {
      game_data.difficulty = Difficulty.EASY;
      state_manager.switch_state(StateType.GAME);
    }
    if (normal_button.is_pressed()) {
      game_data.difficulty = Difficulty.NORMAL;
      state_manager.switch_state(StateType.GAME);
    }
    if (impossible_button.is_pressed()) {
      game_data.difficulty = Difficulty.IMPOSSIBLE;
      state_manager.switch_state(StateType.GAME);
    }
  }
  
  @Override
  void on_draw()
  {
    background(#060606);
    
    // Set font
    textFont(menu_font);
    
    textSize(74);
    fill(250);
    textAlign(CENTER, CENTER);
    text("CHOOSE DIFFICULTY", width/2, height/2 - 240);
    
    easy_button.draw();
    normal_button.draw();
    impossible_button.draw();
  }
}
