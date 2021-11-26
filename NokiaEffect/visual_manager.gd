extends Node

onready var nokia_viewport : ViewportContainer = get_node("/root/MainViewportContainer")
onready var material : ShaderMaterial = nokia_viewport.material
const FLIP_COLORS := "flip_colors"

func flip_colors() -> void:
	set_flip_colors(not get_flip_colors())

func get_flip_colors() -> bool:
	return material.get_shader_param(FLIP_COLORS)

func set_flip_colors(state : bool) -> void:
	material.set_shader_param(FLIP_COLORS, state)

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
