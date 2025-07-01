extends Character
class_name Player

@export var player_1 : bool

func _ready() -> void:
	super()
	for check in input_checks.get_children():
		check.hide()

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
