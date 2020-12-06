class Explosion
{
  float FRAME_TIME = 0.15f;
  int SIZE = 70;
  float SCALE = SIZE / 16;
  
  // type 0 == brick explosion, type 1 == tank explosion
  int x, y, type, frame_index = 0;
  float time = 0;
  
  ArrayList<PImage> explosion = new ArrayList<PImage>();
  
  boolean finished = false;
  
  Explosion(int x, int y, int type){
    this.x = x;
    this.y = y;
    this.type = type;
    if(type == 0){
      explosion.add(loadImage(SPRITES_FOLDER + "explosion_0.png"));
      explosion.add(loadImage(SPRITES_FOLDER + "explosion_1.png"));
      explosion.add(loadImage(SPRITES_FOLDER + "explosion_2.png"));
    }
    else{
      explosion.add(loadImage(SPRITES_FOLDER + "explosion_1.png"));
      explosion.add(loadImage(SPRITES_FOLDER + "explosion_3.png"));
      explosion.add(loadImage(SPRITES_FOLDER + "explosion_4.png"));
      explosion.add(loadImage(SPRITES_FOLDER + "explosion_3.png"));
    }
  }
  
  void update(float delta_time){
    time += delta_time;
    if(time > FRAME_TIME){
      frame_index++;
      time = 0;
    }
    if(frame_index == explosion.size()){
      finished = true;
    }
  }
  
  void draw(){
    float im_width = explosion.get(frame_index).width * SCALE;
    float im_height = explosion.get(frame_index).height * SCALE;
    image(explosion.get(frame_index), x, y, im_width, im_height);
  }
}
