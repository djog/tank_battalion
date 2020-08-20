PImage background;
PImage tank_image;
float scale;
String data_path = "../../data/";
Tank tank;

void setup() {
  fullScreen();
  background(0);
  background = loadImage(data_path + "Background.png");
  scale = height / background.height;
  tank = new Tank(width / 2, height / 2);
  tank_image = loadImage(data_path + "PlayerUp.png");
}

void draw() {
  image(background, scale * background.width / 4, 0, scale * background.width, height);
  image(tank_image, tank.x, tank.y, tank_image.width * scale, tank_image.height * scale);
}
