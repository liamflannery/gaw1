extends Control
@export var player_1 : Character
@export var player_2 : Character
@export var grid : Grid

@export var npcs : Array[NPC]

var characters : Array[Character]

func _ready() -> void:
	characters = [player_1, player_2] ## the idea here is that later characters will be children of a generic class that npcs can use too and we add them all to this array
	characters.append_array(npcs)
	set_npc_moves()
func _process(_delta: float) -> void:
	if player_1.ready_to_move and player_2.ready_to_move:
		move_players()

func move_players():
	player_1.ready_to_move = false
	player_2.ready_to_move = false
	for npc in npcs: 
		npc.ready_to_move = false
		npc.input_checks.hide()
	player_1.input_complete_icon.hide()
	player_2.input_complete_icon.hide()
	for i in range(4):
		
		var proposed_tiles = {} ## key will be a tile that someone wants to go to, value will be an array of all characters that want to go to that tile.
		for char : Character in characters:
			if char.inputs == null || char.inputs.size() <= i:
				continue
			if proposed_tiles.has(char.predict_action(char.inputs[i])):
				proposed_tiles[char.predict_action(char.inputs[i])].append(char)
			else:
				proposed_tiles[char.predict_action(char.inputs[i])] = [char]
		
		## execute on the actions/stumbles now that we know where everyone wants to go
		for tile : Tile in proposed_tiles.keys():
			if proposed_tiles[tile].size() > 1:
				for char : Character in proposed_tiles[tile]:
					await char.do_action(char.inputs[i], false) ## these Characters stumble because they're trying to walk into the same spot
					await get_tree().create_timer(0.5).timeout
			else: ## I'm assuming there'll always be one character here hehe
				await proposed_tiles[tile][0].do_action(proposed_tiles[tile][0].inputs[i], true)
				await get_tree().create_timer(0.5).timeout

		## maybe drop an await here? seems like the traps are getting triggered the turn after you step on them, might have started with my stumble changes
		for tile : Tile in grid.all_tiles:
			await tile.apply_traps()
		for tile: Tile in grid.all_tiles:
			await tile.apply_effects()
		await get_tree().create_timer(0.5).timeout
		for tile in grid.all_tiles:
			await tile.turn_ended()
		await get_tree().create_timer(1).timeout
		
		if Stage.playerDead > 0:
			## show end ui
			break
	player_1.clear_actions()
	player_2.clear_actions()
	for npc in npcs:
		npc.clear_actions()
	set_npc_moves()

func set_npc_moves():
	for npc in npcs:
		npc.choose_actions()
