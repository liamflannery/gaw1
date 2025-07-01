extends Resource
class_name Effect
@export var effect_texture : Texture
@export var flip_image_h : bool = false
@export var flip_image_v : bool = false
func apply_effect(this_tile : Tile, character : Character):
	pass

func turn_ended(this_tile: Tile):
	pass

func can_player_move(this_tile : Tile, character : Character) -> bool:
	return true
