class GameOverState extends State
{
  @Override
  void on_draw()
  {
    background(#060606);
    
    textSize(50);
    fill(250);
    textAlign(CENTER, CENTER);
    text("GAME OVER", width/2, height/2);
  }
}
