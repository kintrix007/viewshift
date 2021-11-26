tool
extends Area2D
signal win

export var black_texture : Texture
export var white_texture : Texture
export var flipped : bool = false setget _set_flipped

onready var sprite := $Sprite
onready var particles := $Particles

func _set_flipped(val : bool) -> void:
	flipped = val

func _ready() -> void:
	sprite.texture = white_texture if flipped else black_texture
	particles.self_modulate = Color(1,1,1) if flipped else Color(0,0,0)

var time : float = 0
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	time += delta
	var offset : float = cos(time * 1.0) / 2 + 0.5
#	sprite.position.y = offset * 10

func _on_Goal_body_entered(body: Node) -> void:
	if Engine.is_editor_hint(): return
	
	if body is Player:
		connect("win", body, "_win")
		emit_signal("win")
