class GameOverState extends State
{  
  Button play_again_button;
  Button menu_button;
  PFont menu_font;
  
  @Override
  void on_start()
  {
    final int BUTTONS_OFFSET = 70;
    final int BUTTONS_SPACING = 40;
    play_again_button = new Button(width / 2, height /2 + BUTTONS_OFFSET, "PLAY AGAIN");
    menu_button = new Button(width / 2, height /2 + BUTTONS_OFFSET + Button.HEIGHT + BUTTONS_SPACING, "MENU");
    
    menu_font = createFont(FONTS_FOLDER + "RetroGaming.ttf", 48.0);
    
    audio_manager.play_sound("game_over.wav"); 
  }
  
  @Override
  void on_update(float delta_time)
  {
    play_again_button.update();
    menu_button.update();
    if (play_again_button.is_pressed()) {
      state_manager.switch_state(StateType.GAME);
    }
    if (menu_button.is_pressed()) {
      state_manager.switch_state(StateType.MENU);
    }
  }
  
  @Override
  void on_draw()
  {
    background(#060606);

    textFont(menu_font);
    textSize(94);
    textAlign(CENTER, CENTER);
    fill(#d34545);
    text("GAME OVER", width/2, height/2 - 240);
    
    fill(255);
    textSize(40);
    text("SCORE: " + game_data.score, width/2, height/2 - 80);
    textSize(36);
    text("HIGH-SCORE: " + game_data.high_score, width/2, height/2 - 30);
    if (game_data.new_best)
    {
      textSize(40);
      fill(#60b555);
      text("NEW HIGHSCORE!", width/2, height/2 - 140);
    }
    play_again_button.draw();
    menu_button.draw();
  }
}
