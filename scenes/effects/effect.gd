extends Resource
class_name Effect
@export var effect_texture : Texture

func apply_effect(this_tile : Tile, character : Character):
	pass

func turn_ended(this_tile: Tile):
	pass

func can_player_move(this_tile : Tile, character : Character) -> bool:
	return true
