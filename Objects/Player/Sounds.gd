extends Node

export var jump : AudioStream
export var switch : AudioStream
export var die : AudioStream
export var win : AudioStream

func _ready() -> void:
	if not GlobalSettings.has_sfx:
		jump = null
		switch = null
		win = null

func play_jump() -> void:
	jump and AudioManager.play_sound(jump)

func play_die() -> void:
	die and AudioManager.play_sound(die, 0)

func play_win() -> void:
	win and AudioManager.play_sound(win)

func play_switch() -> void:
	switch and AudioManager.play_sound(switch)
