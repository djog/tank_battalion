class CreditsState extends State
{
  PFont menu_font;
  
  Button back_button;
  
  final String[] contributors = {"Rijk van Putten", "Rob Krüger", "Max Achternaamloos", "Sjoerd Achternaamloos", "Aram Achternaamloos", "Mart Achternaamloos"};
  
  @Override
  void on_start() {
    menu_font = createFont(FONTS_FOLDER + "RetroGaming.ttf", 128.0);
    back_button = new Button(width / 2, height - 100, "BACK");
  }
  
  @Override
  void on_update(float delta_time) {
    back_button.update();

    if (back_button.is_pressed()) {
      state_manager.switch_state(StateType.MENU);
    }
  }
  
  @Override
  void on_draw()
  {
    background(#060606);
    
    // Set font
    textFont(menu_font);
    
    textSize(64);
    fill(250);
    textAlign(CENTER, CENTER);
    text("CREDITS", width/2, height/2 - 240);
    textSize(28);
    text("Made by DJOG UNO'S 2020 Team @DJOG:", width/2, height/2 - 120);
    int counter = 0;
    textSize(24);
    for (String name : contributors)
    {
      text(name, width/2, height/2 - 60 + counter * 30);
      counter++;
    }
    back_button.draw();
  }
}
