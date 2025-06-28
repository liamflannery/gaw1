extends Control
@export var player_1 : Character
@export var player_2 : Character
@export var grid : Grid

func _process(_delta: float) -> void:
	if player_1.ready_to_move and player_2.ready_to_move:
		move_players()

func move_players():
	player_1.ready_to_move = false
	player_2.ready_to_move = false
	player_1.input_complete_icon.hide()
	player_2.input_complete_icon.hide()
	for i in range(4):
		player_1.do_action(player_1.inputs[i])
		await player_2.do_action(player_2.inputs[i])
		for tile : Tile in grid.all_tiles:
			await tile.apply_tile()
		await get_tree().create_timer(0.4).timeout
		for tile in grid.all_tiles:
			await tile.turn_ended()
		await get_tree().create_timer(0.4).timeout
	player_1.clear_actions()
	player_2.clear_actions()
