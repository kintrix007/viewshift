extends Node

export var bg_music : AudioStream

func _ready() -> void:
	if GlobalSettings.has_music:
		if bg_music: AudioManager.play_music(bg_music)
