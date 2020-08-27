class Grid {
   final int GRID_SIZE = 32;
   final int NODE_SIZE = ARENA_SIZE / GRID_SIZE;
   
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
          image(brick_image, ARENA_X + x * NODE_SIZE, ARENA_Y + y * NODE_SIZE, NODE_SIZE, NODE_SIZE);
        }
        
      }
    }
   }
}
