tool
extends Area2D
signal die

export var black_texture : Texture
export var white_texture : Texture
export var flipped : bool = false setget _set_flipped
var is_inactive : bool = false

onready var sprite_top := $SpriteTop
onready var sprite_bottom := $SpriteBottom
onready var hitbox1 := $HitBox1
onready var hitbox2 := $HitBox2

func _set_flipped(val : bool) -> void:
	flipped = val
	if Engine.is_editor_hint():
		update_sprite_hitbox(flipped)

func update_sprite_hitbox(flipped: bool) -> void:
	if sprite_top == null: sprite_top = $SpriteTop
	if sprite_bottom == null: sprite_bottom = $SpriteBottom
	if hitbox1 == null: hitbox1 = $HitBox1
	if hitbox2 == null: hitbox2 = $HitBox2
	sprite_top.texture = white_texture if flipped else black_texture
	sprite_bottom.texture = white_texture if flipped else black_texture
	sprite_bottom.position.y = 0 if flipped else 20
	hitbox1.position.y = 6.5 if flipped else 23.5
	hitbox2.position.y = 4 if flipped else 26

func _ready() -> void:
	update_sprite_hitbox(flipped)
	
	if not Engine.is_editor_hint():
		_player_flipped(GlobalData.player_flip_state)
		GlobalData.connect("flip", self, "_player_flipped")

func _on_Spike_body_entered(body : Node) -> void:
	if Engine.is_editor_hint(): return
	
	if body is Player:
		connect("die", body, "_die")
		emit_signal("die", self)
		disconnect("die", body, "_die")

func _player_flipped(player_flipped : bool) -> void:
	is_inactive = flipped == player_flipped
	sprite_bottom.visible = is_inactive
