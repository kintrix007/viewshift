extends Node2D

export(String, FILE) var next_level_path : String

func _ready() -> void:
	var white : TileMap = $White
	var black : TileMap = $Black
	var gray  : TileMap = $Gray
	white.modulate = Color.white
	black.modulate = Color.white
	gray.modulate  = Color.white
	
	for y in range(32):
		for x in range(56):
			var cell := gray.get_cell(x, y)
			if cell == TileMap.INVALID_CELL: continue
			gray.set_cell(x, y, (x+y) % 2 + 1)

func load_next_level() -> void:
	SceneManager.change_scene_to_anim(load(next_level_path))

func _on_player_win() -> void:
	if next_level_path:
		load_next_level()
	else:
		# absolute win!!
		pass
