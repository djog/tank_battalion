class AABB // Axis Aligned Bounding Box
{
  public int x1;
  public int x2;
  public int y1;
  public int y2;
  
  public AABB(int x1, int x2, int y1, int y2)
  {
    this.x1 = x1;
    this.x2 = x2;
    this.y1 = y1;
    this.y2 = y2;
  }
  
  public ArrayList<PVector> get_points()
  {
    ArrayList<PVector> points = new ArrayList<PVector>();
    points.add(new PVector(x1, y1));
    points.add(new PVector(x1, y2));
    points.add(new PVector(x2, y1));
    points.add(new PVector(x2, y2));
    return points;
  }

  public void debug()
  {
    println("DEBUG AABB - X1: " + x1 + " X2:" + x2 + " Y1:" + y1 + " Y2:" + y2);
  }
}

static final int NODE_COLLISION_LAYERS = 3; // How many layers of nodes the algorithm should check arround the object - depends on the size of the object
                                            // Higher value means slower performance
public boolean collision_detection(int screen_x, int screen_y, int object_width, int object_height, int[][] nodes) {
  PVector gridCoords = screen_to_grid_coords(screen_x, screen_y);
  int center_x = (int)gridCoords.x;
  int center_y = (int)gridCoords.y;
  
  ArrayList<AABB> obstacles = new ArrayList<AABB>();
  for (int x = - NODE_COLLISION_LAYERS; x <= NODE_COLLISION_LAYERS; x++) {
    for (int y = - NODE_COLLISION_LAYERS; y <= NODE_COLLISION_LAYERS; y++) {
      int target_x = center_x + x;
      int target_y = center_y + y;
      if (target_x >= 0 && target_x < Grid.SIZE_X && target_y >= 0 && target_y < Grid.SIZE_Y)
      {
        int node_value = nodes[target_x][target_y];
        if (node_value == 1)
        {
          PVector screenCoords = grid_to_screen_coords(target_x, target_y);
          if (debug_collision)
          {
            rectMode(CORNER);
            fill(0, 200, 0, 255);
            stroke(0);
            strokeWeight(1);
            rect(screenCoords.x, screenCoords.y, Grid.NODE_SIZE_X, Grid.NODE_SIZE_Y);
          }
          obstacles.add(new AABB((int)screenCoords.x, (int)screenCoords.x + Grid.NODE_SIZE_X, (int)screenCoords.y, (int)screenCoords.y + Grid.NODE_SIZE_Y));
        }
      }
    }
  }
  if (debug_collision)
  {
    rectMode(CENTER);
    fill(50, 50, 200, 255);
    stroke(0);
    strokeWeight(1);
    rect(screen_x, screen_y, object_width, object_height);
  }
  AABB target_object = new AABB(screen_x - object_width/2,  screen_x + object_width/2, screen_y - object_height/2,screen_y + object_height/2);
  boolean did_collide = false;
  for(AABB obstacle : obstacles)
  {
    for(PVector point : obstacle.get_points())
    {
      if (point.x >= target_object.x1 && point.x <= target_object.x2
       && point.y >= target_object.y1 && point.y <= target_object.y2)
       {
          did_collide = true;
          if (debug_collision)
          {
            rectMode(CORNER);
            fill(255, 0, 0, 255);
            rect(obstacle.x1, obstacle.y1, obstacle.x2 - obstacle.x1, obstacle.y2 - obstacle.y1);
          }
          break;
       }
    }
  }
  return did_collide;
}
