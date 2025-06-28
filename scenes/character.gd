extends Control
class_name Character

@onready var grid : Grid = get_tree().get_first_node_in_group("grid")
@export var image : TextureRect
@export var player_1 : bool
@export var input_checks : HBoxContainer
@export var input_complete_icon : NinePatchRect
@export var health_ui : HealthUI
var health : int = 3 :
	set(value):
		health = value
		if health_ui:
			health_ui.set_health(health)
var current_tile : Tile



enum DIRECTION{
	UP, LEFT, RIGHT, DOWN
}
var inputs : Array[DIRECTION]
var ready_to_move : bool = false
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	current_tile = grid.all_tiles.pick_random()
	set_tile(current_tile, true)
	for check in input_checks.get_children():
		check.hide()
	input_complete_icon.hide()


var move_tween : Tween
func set_tile(this_tile : Tile, teleport=false):
	if !this_tile:
		return
	if move_tween and move_tween.is_running():
		move_tween.custom_step(1000000)
		move_tween.kill()
	
	var target_position = this_tile.global_position - size/2 + this_tile.size/2
	if teleport:
		global_position = target_position
	else:
		move_tween = create_tween()
		move_tween.tween_property(self, "global_position", target_position, 0.4)
	
	if move_tween: await move_tween.finished
	current_tile.character_exited(self)
	current_tile = this_tile
	current_tile.character_entered(self)
	




func move_in_direction(direction : DIRECTION):
	var target_tile : Tile
	match direction:
		DIRECTION.UP:
			target_tile = grid.get_north_tile(current_tile)
		DIRECTION.LEFT:
			target_tile = grid.get_west_tile(current_tile)
		DIRECTION.DOWN:
			target_tile = grid.get_south_tile(current_tile)
		DIRECTION.RIGHT:
			target_tile = grid.get_east_tile(current_tile)
	if !target_tile:
		return
	await set_tile(target_tile)
	


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

func do_action(action : DIRECTION):
	await move_in_direction(action)

func damage_player(amount : int):
	health -= amount
	if health <= 0:
		kill_player()

func kill_player():
	pass
	
func add_action(action : DIRECTION):
	if inputs.size() >= 4:
		return
	inputs.append(action)
	var check = input_checks.get_child(inputs.size() - 1)
	if check: check.show()
	if inputs.size() >= 4:
		for child in input_checks.get_children():
			child.hide()
		ready_to_move = true
		input_complete_icon.show()
func clear_actions():
	inputs.clear()
	input_complete_icon.hide()
