################
## HOW TO USE ##
################

1) Add a polyphonic_audio_player.tscn instance anywhere in your scene.
   Ideally in a persistent place where it never moves or is deleted
2) Call Globals.play_sound(<sound_name>) to play a sound once.
3) Call Globals.play_sound_looping(<sound_name>, <my_key>) to play a sound on loop until you tell it to stop
4) Call Globals.stop_sound_looping(<my_key>) to stop the sound loop dispatched with the given key

If a sound is not found for the matching name, it will play the default sound
(which is a small pop sound), this can be used as a placeholder while developing a scene.

Eg. if you want a sound to be played on a given action, just do something like:
	Globals.play_sound("jump") or Globals.play_sound("punch")

And the default sound should play until a matching sound effect is added later.
