import java.lang.*;

class ScorePopup
{
  static final float LIFE_TIME = 0.8  ;
  
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
    
    if (time < (0.3 * LIFE_TIME))
    {
      size += delta_time * 4;
    }
    else 
    {
      
      size -= delta_time * 3;
      if (size < 0.0)
      {
        size = 0.0;
      }
    }
  }
   
  void draw() {
    fill(200, 200, 0);
    textSize(32 * size);
    textAlign(CENTER, CENTER);
    text(new Integer(value).toString(), x, y);
  }
}
