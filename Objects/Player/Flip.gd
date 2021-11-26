extends Node

export var flipped : bool = false
export(int, LAYERS_2D_PHYSICS) var normal_collision_mask : int = 4
export(int, LAYERS_2D_PHYSICS) var flipped_collision_mask : int = 2

onready var player : Player = get_parent()

func _ready() -> void:
	player.collision_mask = flipped_collision_mask if flipped else normal_collision_mask
	GlobalData.player_flip_state = flipped

func flip(up_vec : Vector2):
	if Input.is_action_just_pressed("flip"):
		var overlaps := {
			"above" : player.above_side.get_overlapping_bodies().size(),
			"below" : player.below_side.get_overlapping_bodies().size()
		}
		if overlaps["above" if flipped else "below"] > 0: return
		
		player.move.vel.y = 0
		
		if flipped:
			player.position.y -= 20
			player.collision_mask = normal_collision_mask
			player.sprite.texture = player.black_texture
		else:
			player.position.y += 20
			player.collision_mask = flipped_collision_mask
			player.sprite.texture = player.white_texture
		
		flipped = not flipped
		GlobalData.player_flip_state = flipped
		VisualManager.set_flip_colors(flipped)
		player.sounds.play_switch()
		player.time_standing = 1
