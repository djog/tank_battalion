class MenuState extends State
{
  PFont menu_font;
  
  void on_start() {
    menu_font = createFont(FONTS_FOLDER + "RetroGaming.ttf", 128.0);
  }
  
  void on_input(boolean is_key_down)
  {
    if (is_key_down && keyCode == ' ')
    {
      state_manager.switch_state(StateType.GAME);
    }
  }
  
  void on_draw()
  {
    background(0); // Black background
    
    // Draw the placeholder
    textFont(menu_font);
    textAlign(CENTER,CENTER);
    fill(255, 255, 255); // White
    textSize(64);
    text("TANK BATTALION", width/2, height/2 - 100);
    textSize(32);
    text("This is the menu screen placeholder", width/2, height/2);
    text("Press SPACE to play the game!", width/2, height/2 + 100);
  }
}
