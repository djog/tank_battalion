abstract class State
{
  void on_start() {
  };
  void on_input(boolean is_key_down) {
  }
  void on_update(float delta_time) {
  };
  void on_draw() {
  };
  void on_stop() {
  };
}

enum StateType {
    MENU, 
    GAME, 
    DIFFICULTY_SELECTION,
    CREDITS,
    GAME_OVER,
}

final static StateType DEFAULT_STATE = StateType.MENU;

class StateManager {
  private State current_state;
  private float previous_time;

  public StateManager() {
    current_state = this.build_state(DEFAULT_STATE);
    current_state.on_start();
    previous_time = millis();
  }

  private State build_state(StateType state) {
    switch(state)
    {
    case MENU:
      return new MenuState();
    case GAME:
      return new GameState();
    case CREDITS:
      return new CreditsState();
    case GAME_OVER:
      return new GameOverState();
    case DIFFICULTY_SELECTION:
      return new DifficultyState();
    default:
      println("The state is not added to the build_state() metod!");
      return null;
    }
  }

  public void switch_state(StateType state) {
    current_state.on_stop();
    audio_manager.stop_all_sounds();
    current_state = this.build_state(state);
    current_state.on_start();
  }

  public void handle_input(boolean is_key_down) {
    current_state.on_input(is_key_down);
  }

  public void update_frame() {
    float delta_time = (millis() - previous_time) / 1000;
    previous_time = millis();
    // Update current state
    current_state.on_update(delta_time);
    // Draw current state
    current_state.on_draw();
  }
}
