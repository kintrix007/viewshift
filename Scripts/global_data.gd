extends Node
signal flip

var player_flip_state : bool = false setget _flip_changed

func _flip_changed(new_val : bool) -> void:
	player_flip_state = new_val
	emit_signal("flip", player_flip_state)
