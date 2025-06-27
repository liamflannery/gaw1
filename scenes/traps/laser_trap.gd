extends Trap
class_name Laser

@export var laser_texture : Texture

func apply_trap(this_tile : Tile, character : Character):
	var current_tile = this_tile
	while Stage.get_grid().get_east_tile(current_tile):
		Stage.get_grid().get_east_tile(current_tile).set_effect_texture(laser_texture)
		current_tile = Stage.get_grid().get_east_tile(current_tile)
