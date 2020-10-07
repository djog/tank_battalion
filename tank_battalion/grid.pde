class Grid {
  static final int SIZE = 52;
  static final int NODE_SIZE = ARENA_SIZE / SIZE;

  private int[][] nodes;

  PImage brick_image, brick_1, brick_2, brick_3, brick_4;

  public Grid(int round) {
    nodes = new int[SIZE][SIZE];
    String[] lines = loadStrings(LEVEL_FOLDER + "layout-" + round + ".ini");
    for (int y = 0; y < SIZE; y++) {
      int[] node_values = int(split(lines[y], " "));
      for (int x = 0; x < SIZE; x++) {
        nodes[x][y] = node_values[x];
      }
    }
    physics_manager.update_grid(nodes);

    brick_1 = loadImage(SPRITES_FOLDER + "Brick_1.png");
    brick_2 = loadImage(SPRITES_FOLDER + "Brick_2.png");
    brick_3 = loadImage(SPRITES_FOLDER + "Brick_3.png");
    brick_4 = loadImage(SPRITES_FOLDER + "Brick_4.png");
  }

  void draw() {
    noStroke();
    imageMode(CORNER);
    for (int x = 0; x < SIZE; x++) {
      for (int y = 0; y < SIZE; y++) {
        PVector position = grid_to_screen_coords(x, y);
        if (nodes[x][y] == 1) {
          image(brick_1, position.x, position.y, NODE_SIZE, NODE_SIZE);
        } else if (nodes[x][y] == 2) {
          image(brick_2, position.x, position.y, NODE_SIZE, NODE_SIZE);
        } else if (nodes[x][y] == 3) {
          image(brick_3, position.x, position.y, NODE_SIZE, NODE_SIZE);
        } else if (nodes[x][y] == 4) {
          image(brick_4, position.x, position.y, NODE_SIZE, NODE_SIZE);
        }
      }
    }
  }
}

public static PVector grid_to_screen_coords(int x, int y) {
  return new PVector(ARENA_X + x * Grid.NODE_SIZE, ARENA_Y + y * Grid.NODE_SIZE);
}

public static PVector screen_to_grid_coords(int x, int y) {
  return new PVector((x - ARENA_X) / Grid.NODE_SIZE, (y - ARENA_Y) / Grid.NODE_SIZE);
}
