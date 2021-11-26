tool
extends CPUParticles2D

export var flipped : bool = false

func _ready() -> void:
	modulate = Color(1,1,1) if flipped else Color(0,0,0)
	gravity.y = -1000 if flipped else 1000
	emitting = true
