extends Trap
class_name Laser



func apply_trap(this_tile : Tile, character : Character):
	var current_tile = this_tile
	while Stage.get_grid().get_east_tile(current_tile):
		Stage.get_grid().get_east_tile(current_tile).add_effect(load("res://scenes/effects/laser_effect.tres"))
		current_tile = Stage.get_grid().get_east_tile(current_tile)
