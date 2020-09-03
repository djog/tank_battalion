class Grid {
  static final int SIZE_X = 44;
  static final int SIZE_Y = 46;
  static final int NODE_SIZE_X = ARENA_SIZE / SIZE_X;
  static final int NODE_SIZE_Y = ARENA_SIZE / SIZE_Y;
  static final int CENTER_SIZE = 10;
  
  int[][] nodes;
  
  PImage brick_image;
  
  public Grid() {
    nodes = new int[SIZE_X][SIZE_Y];
    String[] lines = loadStrings(LEVEL_FOLDER + "maze.ini");
    for(int y = 0; y < SIZE_Y; y++){
      int[] node_values = int(split(lines[y], " "));
      for (int x = 0; x < SIZE_X; x++){
        nodes[x][y] = node_values[x];
      }
    }
    
    //for (int x = 0; x < SIZE; x++) {
    //  for (int y = 0; y < SIZE; y++) {
    //    if (x <= 1 || y <= 1 || x >= SIZE - 2 || y >= SIZE - 2)
    //    {
    //      nodes[x][y] = 1;
    //    }
    //    else if (x >= SIZE/2 - CENTER_SIZE/2 && x <= SIZE/2 + CENTER_SIZE/2 && y >= SIZE/2 - CENTER_SIZE/2 && y <= SIZE/2 + CENTER_SIZE/2)
    //    {
    //      nodes[x][y] = 0;
    //    }
    //    else
    //    {
    //      int random_int = (int)random(0,10);
    //      if (random_int == 0)
    //        nodes[x][y] = 1;
    //      else
    //        nodes[x][y] = 0;
    //    }
    //  }
    //}  
  
    brick_image = loadImage(SPRITES_FOLDER + "Bricks.png");
  }
  
  void draw() {
    noStroke();
    rectMode(CORNER);
    for (int x = 0; x < SIZE_X; x++) {
      for (int y = 0; y < SIZE_Y; y++) {
        if (nodes[x][y] == 1) {
          PVector position = grid_to_screen_coords(x, y);
          image(brick_image, position.x, position.y, NODE_SIZE_X, NODE_SIZE_Y);
        }
      }
    }
  }

  public int[][] get_nodes() {
    return nodes;
  }
}

public static PVector grid_to_screen_coords(int x, int y) {
  return new PVector(ARENA_X + x * Grid.NODE_SIZE_X, ARENA_Y + y * Grid.NODE_SIZE_Y);
}

public static PVector screen_to_grid_coords(int x, int y) {
  return new PVector((x - ARENA_X) / Grid.NODE_SIZE_X, (y - ARENA_Y) / Grid.NODE_SIZE_Y);
}
