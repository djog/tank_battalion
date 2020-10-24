enum Difficulty
{
  EASY,
  NORMAL,
  IMPOSSIBLE
}

class GameData
{
  int score;
  int high_score;
  boolean new_best = false;
  Difficulty difficulty = Difficulty.NORMAL;

  void reset_score()
  {
    score = 0;
    new_best = false;
  }
  
  void add_score(int amount)
  {
    score += amount;
    if (score > high_score)
    {
      high_score = score;
      new_best = true;
    }
  }
}
