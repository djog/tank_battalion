import java.util.Map;

class AABB // Axis Aligned Bounding Box
{
  public int x1;
  public int x2;
  public int y1;
  public int y2;

  public AABB(int center_x, int center_y, int collider_width, int collider_height)
  {
    this.x1 = center_x - collider_width/2;
    this.x2 = center_x + collider_width/2;
    this.y1 = center_y - collider_height/2;
    this.y2 = center_y + collider_height/2;
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

public class PhysicsManager
{
  static final int NODE_COLLISION_LAYERS = 3; // How many layers of nodes the algorithm should check arround the object - depends on the size of the object
  // Higher value means slower performance

  private HashMap<Integer, AABB> dynamic_colliders = new HashMap<Integer, AABB>();
  private int collider_id_counter = 0;
  private ArrayList<AABB> static_colliders = new ArrayList<AABB>();

  private int[][] grid_nodes = new int[Grid.SIZE][Grid.SIZE];

  public boolean is_debugging;

  public PhysicsManager()
  {
    // Messy piece of sh*t code but it just works for now :D
    int total_arena_size = ARENA_SIZE + 2 * ARENA_BORDER;
    // Top
    static_colliders.add(new AABB(ARENA_X - ARENA_BORDER + total_arena_size/2, ARENA_BORDER/2, total_arena_size, ARENA_BORDER));
    // Bottom
    static_colliders.add(new AABB(ARENA_X - ARENA_BORDER + total_arena_size/2, ARENA_Y + ARENA_SIZE + ARENA_BORDER/2, total_arena_size, ARENA_BORDER));
    // Left
    static_colliders.add(new AABB(ARENA_X + ARENA_BORDER/2 - ARENA_BORDER, ARENA_Y - ARENA_BORDER + total_arena_size/2, ARENA_BORDER, total_arena_size));
    // Right
    static_colliders.add(new AABB(ARENA_X + ARENA_BORDER/2 + ARENA_SIZE, ARENA_Y - ARENA_BORDER + total_arena_size/2, ARENA_BORDER, total_arena_size));
  }

  public void update_grid(int[][] nodes)
  {
    grid_nodes = nodes;
  }

  public int get_collider_id()
  {
    collider_id_counter += 1;
    return collider_id_counter;
  }

  public void update_collider(int id, AABB value)
  {
    dynamic_colliders.put(id, value);
  }

  public void remove_collider(int id)
  {
    dynamic_colliders.remove(id);
  }

  public void cleanup()
  {
    dynamic_colliders.clear();
  }

  public boolean check_collision(int screen_x, int screen_y, int object_width, int object_height, int ignore_id) {
    PVector gridCoords = screen_to_grid_coords(screen_x, screen_y);
    int center_x = (int)gridCoords.x;
    int center_y = (int)gridCoords.y;

    ArrayList<AABB> grid_obstacles = new ArrayList<AABB>();
    for (int x = - NODE_COLLISION_LAYERS; x <= NODE_COLLISION_LAYERS; x++) {
      for (int y = - NODE_COLLISION_LAYERS; y <= NODE_COLLISION_LAYERS; y++) {
        int target_x = center_x + x;
        int target_y = center_y + y;
        if (target_x >= 0 && target_x < Grid.SIZE && target_y >= 0 && target_y < Grid.SIZE)
        {
          int node_value = grid_nodes[target_x][target_y];
          if (node_value > 0)
          {
            PVector screenCoords = grid_to_screen_coords(target_x, target_y);        
            grid_obstacles.add(new AABB((int)screenCoords.x + Grid.NODE_SIZE/2, (int)screenCoords.y + Grid.NODE_SIZE/2, Grid.NODE_SIZE, Grid.NODE_SIZE));
          }
        }
      }
    }

    ArrayList<AABB> dynamic_obstacles = new ArrayList<AABB>(); 
    for (Map.Entry<Integer, AABB> entry : dynamic_colliders.entrySet())
    {
      Integer id = entry.getKey();
      AABB collider = entry.getValue();
      if (int(id) != ignore_id)
      {
        dynamic_obstacles.add(collider);
      }
    }
    AABB check_box = new AABB(screen_x, screen_y, object_width, object_height);
    boolean did_collide = false;

    ArrayList<AABB> obstacles = (ArrayList)grid_obstacles.clone();
    obstacles.addAll(static_colliders);
    obstacles.addAll(dynamic_obstacles);

    ArrayList<PVector> points = check_box.get_points();
    for (AABB obstacle : obstacles)
    {
      // Check if box is in obstacle
      for (PVector point : points)
      {
        if (point.x >= obstacle.x1 && point.x <= obstacle.x2
          && point.y >= obstacle.y1 && point.y <= obstacle.y2)
        {
          did_collide = true;

          break;
        }
      }

      // Check if obstacle is in box
      for (PVector point : obstacle.get_points())
      {
        if (point.x >= check_box.x1 && point.x <= check_box.x2
          && point.y >= check_box.y1 && point.y <= check_box.y2)
        {
          did_collide = true;
          break;
        }
      }
    }
    return did_collide;
  }

  public void draw_debug()
  {
    if (!is_debugging)
    {
      return;
    }
    ArrayList<AABB> colliders = new ArrayList<AABB>();
    colliders.addAll(static_colliders);
    for (Map.Entry<Integer, AABB> entry : dynamic_colliders.entrySet())
    {
      colliders.add(entry.getValue());
    }
    for (int x = 0; x < Grid.SIZE; x++)
    {
      for (int y = 0; y < Grid.SIZE; y++)
      {
        if (grid_nodes[x][y] > 0)
        {
          PVector screenCoords = grid_to_screen_coords(x, y);        
          colliders.add(new AABB((int)screenCoords.x + Grid.NODE_SIZE/2, (int)screenCoords.y + Grid.NODE_SIZE/2, Grid.NODE_SIZE, Grid.NODE_SIZE));
        }
      }
    }
    rectMode(CORNER);
    fill(0, 20, 200, 150);
    stroke(240);
    strokeWeight(1);
    for (AABB collider : colliders)
    {
      rect(collider.x1, collider.y1, collider.x2 - collider.x1, collider.y2 - collider.y1);
    }
  }
}
