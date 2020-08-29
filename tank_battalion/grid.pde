class Grid {
   static final int GRID_SIZE = 32;
   static final int NODE_SIZE = ARENA_SIZE / GRID_SIZE;
   
   int[][] nodes;
   
   PImage brick_image;
   
   Grid() {
    nodes = new int[GRID_SIZE][GRID_SIZE];
    for (int x = 0; x < GRID_SIZE; x++) {
      for (int y = 0; y < GRID_SIZE; y++) {
        nodes[x][y] = (int)random(0,2);
      }
    }
    
    brick_image = loadImage(SPRITES_FOLDER + "Bricks.png");
   }
   
   void draw() {
     noStroke();
     rectMode(CORNER);
     for (int x = 0; x < GRID_SIZE; x++) {
      for (int y = 0; y < GRID_SIZE; y++) {
        if (nodes[x][y] == 1) {
          PVector position = gridToScreenCoords(x, y);
          image(brick_image, position.x, position.y, NODE_SIZE, NODE_SIZE);
        }
      }
    }
   }
}

public static PVector gridToScreenCoords(int x, int y) {
  return new PVector(ARENA_X + x * Grid.NODE_SIZE, ARENA_Y + y * Grid.NODE_SIZE);
}

public static PVector screenToGridCoords(int x, int y) {
  return new PVector((x - ARENA_X) / Grid.NODE_SIZE, (y - ARENA_Y) / Grid.NODE_SIZE);
}