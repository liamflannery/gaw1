extends TextureRect
class_name Tile

@export var trap : Trap
var tile_position : int

func _ready() -> void:
	if !trap:
		%trap_texture.texture = null
	else:
		%trap_texture.texture = trap.trap_texture
	%effect_texture.texture = null

func character_entered(character : Character):
	if trap:
		await trap.apply_trap(self, character)

func set_effect_texture(to_texture : Texture):
	%effect_texture.texture = to_texture
