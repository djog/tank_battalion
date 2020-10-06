class MenuState extends State
{
  PFont menu_font;
  
  Button play_button;
  Button credits_button;
  Button quit_button;
  
  @Override
  void on_start() {
    menu_font = createFont(FONTS_FOLDER + "RetroGaming.ttf", 128.0);
    final int BUTTONS_OFFSET = 70;
    final int BUTTONS_SPACING = 40;
    play_button = new Button(width / 2, height /2 + BUTTONS_OFFSET, "PLAY");
    credits_button = new Button(width / 2, height /2 + BUTTONS_OFFSET + Button.HEIGHT + BUTTONS_SPACING, "CREDITS");
    quit_button = new Button(width / 2, height /2 + BUTTONS_OFFSET + 2*Button.HEIGHT + 2*BUTTONS_SPACING, "QUIT");
  }
  
  @Override
  void on_update(float delta_time) {
    play_button.update();
    credits_button.update();
    quit_button.update();
    if (play_button.is_pressed()) {
      state_manager.switch_state(StateType.GAME);
    }
    if (credits_button.is_pressed()) {
      
    }
    if (quit_button.is_pressed())
    {
      exit();
    }
  }
  
  @Override
  void on_draw()
  {
    background(#060606);
    
    textSize(94);
    fill(#d34545);
    text("TANK BATTALION", width/2, height/2 - 240);
    textSize(32);
    fill(#F98383);
    text("2020 RECREATION IN PROCESSING", width/2, height/2-156);
    final int PADDING = 8;
    fill(250);
    textSize(24);
    textAlign(LEFT, BOTTOM);
    text("DJOG UNOS 2020", PADDING, height - PADDING);
    textAlign(RIGHT, BOTTOM);
    text("github.com/djog/djog_unos_2020", width - PADDING, height - PADDING);
    
    // Set font
    textFont(menu_font);
    
    
    play_button.draw();
    credits_button.draw();
    quit_button.draw();
  }
}
