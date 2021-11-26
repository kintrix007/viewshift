extends Node

var sound_effect_player := AudioStreamPlayer.new()
var music_player := AudioStreamPlayer.new()


func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	add_child(sound_effect_player)
	add_child(music_player)

func play_sound(audio : AudioStream, db : float = -10) -> void:
	music_player.stream_paused = true
	
	sound_effect_player.set_stream(audio)
	sound_effect_player.volume_db = db
	sound_effect_player.play()
	
	yield(sound_effect_player, "finished")
	music_player.stream_paused = false

func play_music(music : AudioStream) -> void:
	music_player.stop()
	music_player.stream = music
	music_player.play()
