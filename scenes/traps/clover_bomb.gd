extends Trap
class_name Clover_Bomb


func apply_trap(this_tile : Tile, character : Character):
	var current_tile = this_tile
	if Stage.get_grid().get_east_tile(this_tile):
		Stage.get_grid().get_east_tile(this_tile).add_effect(load("res://scenes/effects/laser_effect.tres"))
	if Stage.get_grid().get_north_tile(this_tile):
		Stage.get_grid().get_north_tile(this_tile).add_effect(load("res://scenes/effects/laser_effect.tres"))
	if Stage.get_grid().get_west_tile(this_tile):
		Stage.get_grid().get_west_tile(this_tile).add_effect(load("res://scenes/effects/laser_effect.tres"))
	if Stage.get_grid().get_south_tile(this_tile):
		Stage.get_grid().get_south_tile(this_tile).add_effect(load("res://scenes/effects/laser_effect.tres"))
