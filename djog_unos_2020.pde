PImage background;

void setup() {
  size(256, 192);
  background = loadImage("data/Background.png");
}

void draw() {
  image(background, 0, 0);
}
