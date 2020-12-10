import java.util.Map;

static final byte DEFAULT_LAYER = 0b0001; 
static final byte ENVIRONMENT_LAYER = 0b0010;
static final byte PLAYER_LAYER = 0b0100;
static final byte ENEMY_LAYER = 0b1000;
static final byte ALL_LAYERS = 0b1111;

enum ColliderParentType
{
  NONE, 
  PLAYER, 
  ENEMY,
  FLAG,
  WALL,
}

class AABB // Axis Aligned Bounding Box
{
  public int x1;
  public int x2;
  public int y1;
  public int y2;

  public int layer_mask;
  public Object parent;
  public ColliderParentType parent_type = ColliderParentType.NONE;

  public AABB(int center_x, int center_y, int collider_width, int collider_height, byte layer_mask)
  {
    this.x1 = center_x - collider_width/2;
    this.x2 = center_x + collider_width/2;
    this.y1 = center_y - collider_height/2;
    this.y2 = center_y + collider_height/2;
    this.layer_mask = layer_mask;
  }

  public AABB(int center_x, int center_y, int collider_width, int collider_height, byte layer_mask, ColliderParentType parent_type, Object parent)
  {
    this.x1 = center_x - collider_width/2;
    this.x2 = center_x + collider_width/2;
    this.y1 = center_y - collider_height/2;
    this.y2 = center_y + collider_height/2;
    this.layer_mask = layer_mask;

    this.parent = parent;
    this.parent_type = parent_type;
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

  private Grid grid_ref;

  private ArrayList<AABB> collided_objects = new ArrayList<AABB>();

  public boolean is_debugging;

  public PhysicsManager()
  {
    // Messy piece of sh*t code but it just works for now :D
    int total_arena_size = ARENA_SIZE + 2 * ARENA_BORDER;
    // Top
    static_colliders.add(new AABB(ARENA_X - ARENA_BORDER + total_arena_size/2, ARENA_BORDER/2, total_arena_size, ARENA_BORDER, ENVIRONMENT_LAYER));
    // Bottom
    static_colliders.add(new AABB(ARENA_X - ARENA_BORDER + total_arena_size/2, ARENA_Y + ARENA_SIZE + ARENA_BORDER/2, total_arena_size, ARENA_BORDER, ENVIRONMENT_LAYER));
    // Left
    static_colliders.add(new AABB(ARENA_X + ARENA_BORDER/2 - ARENA_BORDER, ARENA_Y - ARENA_BORDER + total_arena_size/2, ARENA_BORDER, total_arena_size, ENVIRONMENT_LAYER));
    // Right
    static_colliders.add(new AABB(ARENA_X + ARENA_BORDER/2 + ARENA_SIZE, ARENA_Y - ARENA_BORDER + total_arena_size/2, ARENA_BORDER, total_arena_size, ENVIRONMENT_LAYER));
  }

  public void update_grid(Grid grid)
  {
    grid_ref = grid;
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

  public ArrayList<AABB> get_collided_objects() {
    return collided_objects;
  }

  ArrayList<AABB> get_nearby_node_colliders(int grid_x, int grid_y)
  {
    ArrayList<AABB> node_colliders = new ArrayList<AABB>();
    for (int x = - NODE_COLLISION_LAYERS; x <= NODE_COLLISION_LAYERS; x++) {
      for (int y = - NODE_COLLISION_LAYERS; y <= NODE_COLLISION_LAYERS; y++) {
        int target_x = grid_x + x;
        int target_y = grid_y + y;
        if (target_x >= 0 && target_x < Grid.SIZE && target_y >= 0 && target_y < Grid.SIZE)
        {
          int node_value = grid_ref.nodes[target_x][target_y];
          if (node_value > 0)
          {
            PVector screenCoords = grid_to_screen_coords(target_x, target_y);        
            node_colliders.add(new AABB((int)screenCoords.x + Grid.NODE_SIZE/2, (int)screenCoords.y + Grid.NODE_SIZE/2, Grid.NODE_SIZE, Grid.NODE_SIZE, ENVIRONMENT_LAYER, ColliderParentType.WALL, null));
          }
        }
      }
    }
    return node_colliders;
  }

  public void remove_colliding_grid_nodes(int screen_x, int screen_y, int object_width, int object_height)
  {
    PVector gridCoords = screen_to_grid_coords(screen_x, screen_y);
    int center_x = (int)gridCoords.x;
    int center_y = (int)gridCoords.y;

    AABB check_box = new AABB(screen_x, screen_y, object_width, object_height, byte(0));
    ArrayList<PVector> points = check_box.get_points();

    for (int x = - NODE_COLLISION_LAYERS; x <= NODE_COLLISION_LAYERS; x++) {
      for (int y = - NODE_COLLISION_LAYERS; y <= NODE_COLLISION_LAYERS; y++) {
        int target_x = center_x + x;
        int target_y = center_y + y;
        if (target_x >= 0 && target_x < Grid.SIZE && target_y >= 0 && target_y < Grid.SIZE)
        {
          int node_value = grid_ref.nodes[target_x][target_y];
          if (node_value > 0)
          {
            PVector screenCoords = grid_to_screen_coords(target_x, target_y);   
            AABB node_collider = new AABB((int)screenCoords.x + Grid.NODE_SIZE/2, (int)screenCoords.y + Grid.NODE_SIZE/2, Grid.NODE_SIZE, Grid.NODE_SIZE, byte(0));

            // Check collision with the grid node
            boolean did_collide = false;

            // Check if box is in obstacle
            for (PVector point : points)
            {
              if (point.x >= node_collider.x1 && point.x <= node_collider.x2
                && point.y >= node_collider.y1 && point.y <= node_collider.y2)
              {
                did_collide = true;
                break;
              }
            }

            // Check if obstacle is in box
            for (PVector point : node_collider.get_points())
            {
              if (point.x >= check_box.x1 && point.x <= check_box.x2
                && point.y >= check_box.y1 && point.y <= check_box.y2)
              {
                did_collide = true;
                break;
              }
            }

            // Remove the node if collided
            if (did_collide)
            {
              grid_ref.nodes[target_x][target_y] = 0;
            }
          }
        }
      }
    }
  }

  public boolean check_collision(int screen_x, int screen_y, int object_width, int object_height, int ignore_id, byte layer_mask) {
    collided_objects.clear();

    PVector gridCoords = screen_to_grid_coords(screen_x, screen_y);
    int center_x = (int)gridCoords.x;
    int center_y = (int)gridCoords.y;

    ArrayList<AABB> grid_obstacles = get_nearby_node_colliders(center_x, center_y);

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
    AABB check_box = new AABB(screen_x, screen_y, object_width, object_height, layer_mask);
    boolean did_collide = false;

    ArrayList<AABB> obstacles = (ArrayList)grid_obstacles.clone();
    obstacles.addAll(static_colliders);
    obstacles.addAll(dynamic_obstacles);

    ArrayList<PVector> points = check_box.get_points();
    for (AABB obstacle : obstacles)
    {
      // Skip if obstacle layer can't collide with check
      if ((obstacle.layer_mask & check_box.layer_mask) == 0)
      {
        continue;
      }

      // Check if box is in obstacle
      for (PVector point : points)
      {
        if (point.x >= obstacle.x1 && point.x <= obstacle.x2
          && point.y >= obstacle.y1 && point.y <= obstacle.y2)
        {
          did_collide = true;
          collided_objects.add(obstacle);
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
          collided_objects.add(obstacle);
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
        if (grid_ref.nodes[x][y] > 0)
        {
          PVector screenCoords = grid_to_screen_coords(x, y);        
          colliders.add(new AABB((int)screenCoords.x + Grid.NODE_SIZE/2, (int)screenCoords.y + Grid.NODE_SIZE/2, Grid.NODE_SIZE, Grid.NODE_SIZE, ENVIRONMENT_LAYER));
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
