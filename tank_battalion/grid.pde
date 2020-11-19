class Grid {
  static final int SIZE_X = 44;
  static final int SIZE_Y = 46;
  static final int NODE_SIZE_X = ARENA_SIZE / SIZE_X;
  static final int NODE_SIZE_Y = ARENA_SIZE / SIZE_Y;

  private int[][] nodes;

  PImage brick_image, brick_1, brick_2, brick_3, brick_4;

  public Grid(int round) {
    nodes = new int[SIZE_X][SIZE_Y];
    String[] lines = loadStrings(LEVEL_FOLDER + "layout-" + round + ".ini");
    for (int y = 0; y < SIZE_Y; y++) {
      int[] node_values = int(split(lines[y], " "));
      for (int x = 0; x < SIZE_X; x++) {
        nodes[x][y] = node_values[x];
      }
    }
    physics_manager.update_grid(this);

    brick_1 = loadImage(SPRITES_FOLDER + "Brick_1.png");
    brick_2 = loadImage(SPRITES_FOLDER + "Brick_2.png");
    brick_3 = loadImage(SPRITES_FOLDER + "Brick_3.png");
    brick_4 = loadImage(SPRITES_FOLDER + "Brick_4.png");
  }

  void draw() {
    noStroke();
    imageMode(CORNER);
    for (int x = 0; x < SIZE_X; x++) {
      for (int y = 0; y < SIZE_Y; y++) {
        PVector position = grid_to_screen_coords(x, y);
        if (nodes[x][y] == 1) {
          image(brick_1, position.x, position.y, NODE_SIZE_X, NODE_SIZE_Y);
        } else if (nodes[x][y] == 2) {
          image(brick_2, position.x, position.y, NODE_SIZE_X, NODE_SIZE_Y);
        } else if (nodes[x][y] == 3) {
          image(brick_3, position.x, position.y, NODE_SIZE_X, NODE_SIZE_Y);
        } else if (nodes[x][y] == 4) {
          image(brick_4, position.x, position.y, NODE_SIZE_X, NODE_SIZE_Y);
        }
      }
    }
  }
}

public static PVector grid_to_screen_coords(int x, int y) {
  return new PVector(ARENA_X + x * Grid.NODE_SIZE_X, ARENA_Y + y * Grid.NODE_SIZE_Y);
}

public static PVector screen_to_grid_coords(int x, int y) {
  return new PVector((x - ARENA_X) / Grid.NODE_SIZE_X, (y - ARENA_Y) / Grid.NODE_SIZE_Y);
}
