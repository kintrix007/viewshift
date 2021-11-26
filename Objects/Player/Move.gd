extends Node

onready var player : Player = get_parent()

export var max_speed : float = 290.0
export var speed : float = 7000.0
export var mid_air_control : float = 0.5
export var gravity : float = 4000.0
export var gravitiy_at_peak : float = 0.45
export var jump_strength : float = 750.0
export var jump_cancel_strength : float = 0.5
export var friction : float = 0.68
export var max_slides : int = 6
export var vel := Vector2(0, 0)

var frames_falling : int = 10
var frames_stopping : int = 10
var frames_jump_pressed : int = 0

func move(delta : float, up_vec : Vector2) -> void:
	var inputs : float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	# gravity affects you less at the peak of the jump
	if (
		-100 + (100 * up_vec.y) < vel.y and
		vel.y < 100 + (100 * up_vec.y)
	):
		vel.y += gravity * gravitiy_at_peak * delta * -up_vec.y
	else:
		vel.y += gravity * delta * -up_vec.y
	
	if frames_falling < 4:
		vel.x += inputs * speed * delta
	else:
		# only a fraction of the control mid-air
		vel.x += inputs * speed * mid_air_control * delta
	vel.x = clamp(vel.x, -max_speed, max_speed)
	
	if Input.is_action_just_pressed("jump"):
		frames_jump_pressed = 5
	
	if player.is_on_floor():
		frames_falling = 0
		# friction applied after clamping, results in speedy jump
#		vel.x += (-vel.x + vel.x * friction) * offset_delta
		vel.x *= pow(friction, delta * 60)
	else:
		frames_falling += 1
	
	# if pressed jump 4 frames early or 3 frames late, still do a jump
	if frames_jump_pressed > 0 and frames_falling < 4:
			vel.y = jump_strength * up_vec.y
			player.sounds.play_jump()
			frames_falling = 5
	
	# letting go of jump mid air decreases jump height
	if vel.y * up_vec.y > 0:
		if not Input.is_action_pressed("jump"):
			vel.y *= jump_cancel_strength
	
	frames_jump_pressed -= 1
	var temp_vel := player.move_and_slide(vel, up_vec, false, max_slides)
	if temp_vel.length() < vel.length():
		frames_stopping += 1
		# if we just landed don't slide for 5 frames
		if vel.y * up_vec.y < 0:
			vel = temp_vel
			frames_stopping = 0
	else:
		frames_stopping = 0
	
	# only stop movement, if it came in contact for more than 5 frames
	if frames_stopping > 5:
		vel = temp_vel
	
	# if stopped, snap to grid
	if abs(vel.x) < 0.2:
		vel.x = 0
		player.position.x = round((player.position.x + sign(vel.x) * 5) / 10) * 10
