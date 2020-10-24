import processing.sound.*;
import java.util.HashMap;

class AudioManager
{
  HashMap<String, SoundFile> sounds = new HashMap<String, SoundFile>();

  PApplet applet_ref;

  public AudioManager(PApplet parent)
  {
    applet_ref = parent;
  }

  public void play_sound(String file_name)
  {
    if (!sounds.containsKey(file_name))
    {
      SoundFile sound = new SoundFile(applet_ref, SOUNDS_FOLDER + file_name);
      sound.play();
      sounds.put(file_name, sound);
    } else
    {
      SoundFile sound = sounds.get(file_name);
      if (!sound.isPlaying())
      {
        sound.play();
      }
    }
  }

  public void stop_sound(String file_name)
  {
    SoundFile sound = sounds.get(file_name);
    if (sound != null)
    {
      sound.stop();
    }
  }
  
  public void stop_all_sounds()
  {
    for (SoundFile sound : sounds.values()) {
      sound.stop();
    }
  }
}
