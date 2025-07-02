extends Character
class_name Player

@export var player_1 : bool
@export var player_2_colour : Color

func _ready() -> void:
	super()
	for check in input_checks.get_children():
		check.hide()
	if !player_1:
		image.modulate = player_2_colour

func _process(_delta: float) -> void:
	if player_1:
		if Input.is_action_just_pressed("player_1_move_up"):
			add_action(DIRECTION.UP)
		elif Input.is_action_just_pressed("player_1_move_left"):
			add_action(DIRECTION.LEFT)
		elif Input.is_action_just_pressed("player_1_move_right"):
			add_action(DIRECTION.RIGHT)
		elif Input.is_action_just_pressed("player_1_move_down"):
			add_action(DIRECTION.DOWN)
	else:
		if Input.is_action_just_pressed("player_2_move_up"):
			add_action(DIRECTION.UP)
		elif Input.is_action_just_pressed("player_2_move_left"):
			add_action(DIRECTION.LEFT)
		elif Input.is_action_just_pressed("player_2_move_right"):
			add_action(DIRECTION.RIGHT)
		elif Input.is_action_just_pressed("player_2_move_down"):
			add_action(DIRECTION.DOWN)

func add_action(direction : DIRECTION):
	super(direction)
	var check = input_checks.get_child(inputs.size() - 1)
	if check: check.show()
	if inputs.size() >= 4:
		for child in input_checks.get_children():
			child.hide()
		ready_to_move = true
		input_complete_icon.show()


func kill_player():
	if dead:
		return
	dead = true
	
	image.flip_v = true
	image.modulate = Color(0.1, 0.1, 0.1, 1)
	if health_ui:
		health_ui.lil_guy.flip_v = true
		health_ui.lil_guy.modulate = Color(0.1, 0.1, 0.1, 1)
	Stage.playerDead += 1 if player_1 else 2 ## this way if both players die together we'll know because it'll be 3 lol
	input_checks.hide()
	if current_tile:
		current_tile.character_exited(self)
