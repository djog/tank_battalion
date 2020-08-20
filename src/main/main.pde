PImage background;
int background_offset;
int background_width;
String data_path = "../../data/";

void setup() {
  fullScreen();
  background(0);
  background = loadImage(data_path + "Background.png");
  background_width = height / background.height * background.width;
  background_offset = background_width / 4;
}

void draw() {
  image(background, background_offset, 0, background_width, height);
}
