extends Node

onready var effect_container : ViewportContainer =\
	get_node("/root/MainViewportContainer/Viewport/TransitionContainer")
onready var nokia_root : Node = effect_container.get_node("Viewport/World")

const LEVEL1 := "res://Scenes/Levels/Level1.tscn"
#const LEVEL1 := "res://Scenes/Levels/Level8.tscn"

var tween := Tween.new()
var current_scene : PackedScene = null
var current_world : Node = null

func _ready() -> void:
	add_child(tween)
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	for child in nokia_root.get_children():
		child.free()
	
	
	yield(get_tree().create_timer(1), "timeout")
	change_scene_to_anim(load(LEVEL1))

func change_scene_to(new_scene : PackedScene) -> void:
	if current_world: current_world.queue_free()
	current_scene = new_scene
	
	VisualManager.set_flip_colors(false)
	
	current_world = current_scene.instance()
	nokia_root.add_child(current_world)

func change_scene(path : String) -> void:
	change_scene_to(load(path))

func change_scene_to_anim(scene : PackedScene) -> void:
	print("changing scene...")
	if tween.is_active():
		yield(tween, "tween_all_completed")
	
	get_tree().paused = true
	tween.interpolate_method(
		self, "set_effect_state", 0.0, 1.0,
		0.75, Tween.TRANS_SINE, Tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_all_completed")
	change_scene_to(scene)
	tween.interpolate_method(
		self, "set_effect_state", 1.0, 2.0,
		0.75, Tween.TRANS_SINE, Tween.EASE_IN
	)
	tween.start()
	yield(tween, "tween_all_completed")
	get_tree().paused = false
	set_effect_state(0.0)

func set_effect_state(state : float) -> void:
	var effect_material : ShaderMaterial = effect_container.material
	effect_material.set_shader_param("effect_range", fmod(state, 2.0))

func reload_scene() -> void:
	change_scene_to(current_scene)

func reload_scene_anim() -> void:
	change_scene_to_anim(current_scene)
