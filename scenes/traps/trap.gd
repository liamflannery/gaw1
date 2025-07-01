extends Resource
class_name Trap
@export var trap_texture : Texture
@export var flip_image_h : bool = false
@export var flip_image_v : bool = false
@export var rotate_degrees : int = 0
func apply_trap(this_tile : Tile, character : Character):
	pass

func turn_ended(this_tile : Tile, character : Character):
	pass
