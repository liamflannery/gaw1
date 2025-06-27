extends Node

var grid : Grid

func register_grid(new_grid : Grid):
	grid = new_grid

func get_grid() -> Grid:
	return grid
