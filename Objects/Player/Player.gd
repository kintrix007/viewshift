extends KinematicBody2D
class_name Player
signal win

export var explosion_particles : PackedScene
export(Texture) var black_texture
export(Texture) var white_texture

onready var move : Node = $Move
onready var flip : Node = $Flip
onready var sounds : Node = $Sounds
onready var sprite : Sprite = $Sprite
onready var below_side : Area2D = $BelowSideArea
onready var above_side : Area2D = $AboveSideArea

var dead : bool = false
var won : bool = false
var time_standing : float = 0

func _ready() -> void:
	set_flipped_texture(flip.flipped)
	flicker_while_standing()

func set_flipped_texture(flipped: bool) -> void:
	sprite.texture = white_texture if flipped else black_texture

func _physics_process(delta: float) -> void:
	var up_vec := Vector2.DOWN if flip.flipped else Vector2.UP
	move.move(delta, up_vec)
	flip.flip(up_vec)
	
	if move.vel.length() < 10:
		time_standing += delta
	else:
		time_standing = 0

func flicker() -> void:
	set_flipped_texture(not flip.flipped)
	yield(get_tree().create_timer(0.12), "timeout")
	set_flipped_texture(flip.flipped)

func flicker_while_standing() -> void:
	while true:
		if time_standing > 2.0:
			for i in range(3):
				if dead or won: return
				if not time_standing > 2.0: break
				flicker()
				yield(get_tree().create_timer(0.35), "timeout")
			time_standing = 0
		
		if dead or won: return
		yield(get_tree().create_timer(0.2), "timeout")


func _win() -> void:
	won = true
	set_process(false)
	set_physics_process(false)
	hide()
	sounds.play_win()
	print("player won")
	
	yield(get_tree().create_timer(0.15), "timeout")
	emit_signal("win")

func _die(killed_by : Area2D) -> void:
	if not dead:
		dead = true
		set_process(false)
		set_physics_process(false)
		sounds.play_die()
		print("player_died")
		hide()
		
		if explosion_particles:
			var explosion : CPUParticles2D = explosion_particles.instance()
			explosion.flipped = flip.flipped
			explosion.position = position
			get_parent().add_child(explosion)
		
		yield(get_tree().create_timer(1), "timeout")
		SceneManager.reload_scene_anim()
