import java.lang.*;

class ScorePopup
{
  static final float LIFE_TIME = 0.8;
  static final float SIZE_MULTIPLIER = 0.5;
  
  public boolean is_destroyed;
  
  int x, y, value;
  float size = 1.0;
  float time;
  
  ScorePopup(int x, int y, int value) {
    this.x = x;
    this.y = y;
    this.value = value;
  }
  
  void update(float delta_time) {
    time += delta_time;
     
    if (time >= LIFE_TIME)
    {
      is_destroyed = true;
    }
    
    size = SIZE_MULTIPLIER * (-20 * time * time + 13 * time + 2); 
    if (size <= 0.0)
    {
      size = 0.0;
    }
  }
   
  void draw() {
    fill(250, 250, 0);
    float text_size = 30 * size;
    if (text_size <= 0)
    {
      text_size = 1;
    }
    textSize(text_size);
    
    textAlign(CENTER, CENTER);
    text(new Integer(value).toString(), x, y);
  }
}
