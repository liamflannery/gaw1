extends GridContainer
class_name Grid


var all_tiles : Array[Tile]
var total_tiles : int
var total_columns : int

func _ready() -> void:
	for child in get_children():
		all_tiles.append(child)
		child.tile_position = child.get_index()
	total_tiles = get_child_count()
	total_columns = columns
	Stage.register_grid(self)

	
func get_north_tile(from_tile : Tile) -> Tile:
	var north_position = from_tile.tile_position - total_columns
	if north_position < 0:
		return null
	return all_tiles[north_position]

func get_south_tile(from_tile : Tile) -> Tile:
	var south_position = from_tile.tile_position + total_columns
	if south_position >= total_tiles:
		return null
	return all_tiles[south_position]

func get_east_tile(from_tile : Tile) -> Tile:
	var current_row = from_tile.tile_position / total_columns
	var east_position = from_tile.tile_position + 1
	var east_row = east_position / total_columns
	if east_row != current_row or east_position >= total_tiles:
		return null
	return all_tiles[east_position]

func get_west_tile(from_tile : Tile) -> Tile:
	var current_row = from_tile.tile_position / total_columns
	var west_position = from_tile.tile_position - 1
	var west_row = west_position / total_columns
	if west_position < 0 or west_row != current_row:
		return null
	return all_tiles[west_position]
