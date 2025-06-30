extends Trap
class_name Laser

@export var shooting_direction : Character.DIRECTION


func apply_trap(this_tile : Tile, character : Character):
	var current_tile = this_tile
	match shooting_direction:
		Character.DIRECTION.UP:
			while Stage.get_grid().get_north_tile(current_tile):
				Stage.get_grid().get_north_tile(current_tile).add_effect(load("res://scenes/effects/laser_effect.tres"))
				current_tile = Stage.get_grid().get_north_tile(current_tile)
		Character.DIRECTION.RIGHT:
			while Stage.get_grid().get_east_tile(current_tile):
				Stage.get_grid().get_east_tile(current_tile).add_effect(load("res://scenes/effects/laser_effect.tres"))
				current_tile = Stage.get_grid().get_east_tile(current_tile)
		Character.DIRECTION.DOWN:
			while Stage.get_grid().get_south_tile(current_tile):
				Stage.get_grid().get_south_tile(current_tile).add_effect(load("res://scenes/effects/laser_effect.tres"))
				current_tile = Stage.get_grid().get_south_tile(current_tile)
		Character.DIRECTION.LEFT:
			while Stage.get_grid().get_west_tile(current_tile):
				Stage.get_grid().get_west_tile(current_tile).add_effect(load("res://scenes/effects/laser_effect.tres"))
				current_tile = Stage.get_grid().get_west_tile(current_tile)
