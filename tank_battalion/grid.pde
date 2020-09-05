class Grid {
  static final int SIZE = 44;
  static final int NODE_SIZE = ARENA_SIZE / SIZE;
  static final int CENTER_SIZE = 10;
  
  private int[][] nodes;
  
  PImage brick_image;
  
  public Grid() {
    nodes = new int[SIZE][SIZE];
    for (int x = 0; x < SIZE; x++) {
      for (int y = 0; y < SIZE; y++) {
        if (x >= SIZE/2 - CENTER_SIZE/2 && x <= SIZE/2 + CENTER_SIZE/2 && y >= SIZE/2 - CENTER_SIZE/2 && y <= SIZE/2 + CENTER_SIZE/2)
        {
          nodes[x][y] = 0;
        }
        else
        {
          int random_int = (int)random(0,40);
          if (random_int == 0)
            nodes[x][y] = 1;
          else
            nodes[x][y] = 0;
        }
      }
    }  
  
    brick_image = loadImage(SPRITES_FOLDER + "Bricks.png");
    physics_manager.update_grid(nodes);
  }
  
  void draw() {
    noStroke();
    rectMode(CORNER);
    for (int x = 0; x < SIZE; x++) {
      for (int y = 0; y < SIZE; y++) {
        if (nodes[x][y] == 1) {
          PVector position = grid_to_screen_coords(x, y);
          image(brick_image, position.x, position.y, NODE_SIZE, NODE_SIZE);
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
