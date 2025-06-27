extends Control
class_name Character

@onready var grid : Grid = get_tree().get_first_node_in_group("grid")
@export var image : TextureRect
@export var player_1 : bool
@export var input_checks : HBoxContainer
@export var input_complete_icon : TextureRect
var current_tile : Grid.Tile
enum DIRECTION{
	NORTH, EAST, SOUTH, WEST
}
var direction_facing : DIRECTION = DIRECTION.NORTH

enum ACTION{
	FORWARD, ROTATE_CLOCKWISE, ROTATE_ANTICLOCKWISE
}
var inputs : Array[ACTION]
var ready_to_move : bool = false
func _ready() -> void:
	set_direction(0, true)
	await get_tree().create_timer(0.1).timeout
	set_tile(grid.all_tiles.pick_random(), true)
	for check in input_checks.get_children():
		check.hide()
	input_complete_icon.hide()


var move_tween : Tween
func set_tile(this_tile : Grid.Tile, teleport=false):
	if !this_tile or !this_tile.tile_object:
		return
	if move_tween and move_tween.is_running():
		move_tween.custom_step(1000000)
		move_tween.kill()
	
	var target_position = this_tile.tile_object.global_position - size/2 + this_tile.tile_object.size/2
	if teleport:
		global_position = target_position
	else:
		move_tween = create_tween()
		move_tween.tween_property(self, "global_position", target_position, 0.5)
	current_tile = this_tile
	if move_tween: await move_tween.finished

var rotate_tween : Tween
func set_direction(direction : int, teleport=false):
	if rotate_tween and rotate_tween.is_running():
		rotate_tween.kill()
	var target_rotation = 90 * direction
	
	if teleport:
		image.rotation_degrees = target_rotation
	else:
		var current_rotation = image.rotation_degrees
		var diff = target_rotation - current_rotation
		if diff > 180:
			target_rotation -= 360
		elif diff < -180:
			target_rotation += 360
		
		rotate_tween = create_tween()
		rotate_tween.tween_property(image, "rotation_degrees", target_rotation, 0.5)
		rotate_tween.tween_callback(func(): image.rotation_degrees = fmod(image.rotation_degrees, 360))
	direction_facing = direction as DIRECTION
	if rotate_tween: await rotate_tween.finished


func move_forward():
	var target_tile : Grid.Tile
	match direction_facing:
		DIRECTION.NORTH:
			target_tile = grid.get_north_tile(current_tile)
		DIRECTION.EAST:
			target_tile = grid.get_east_tile(current_tile)
		DIRECTION.SOUTH:
			target_tile = grid.get_south_tile(current_tile)
		DIRECTION.WEST:
			target_tile = grid.get_west_tile(current_tile)
	if !target_tile:
		return
	await set_tile(target_tile)

func rotate_character(clockwise=true):
	var new_direction = direction_facing + (1 if clockwise else -1)
	if new_direction > 3:
		new_direction = 0 as DIRECTION
	if new_direction < 0:
		new_direction = 3 as DIRECTION
	await set_direction(new_direction)

func _process(_delta: float) -> void:
	if player_1:
		if Input.is_action_just_pressed("player_1_move_forward"):
			add_action(ACTION.FORWARD)
		elif Input.is_action_just_pressed("player_1_rotate_clockwise"):
			add_action(ACTION.ROTATE_CLOCKWISE)
		elif Input.is_action_just_pressed("player_1_rotate_anticlockwise"):
			add_action(ACTION.ROTATE_ANTICLOCKWISE)
	else:
		if Input.is_action_just_pressed("player_2_move_forward"):
			add_action(ACTION.FORWARD)
		elif Input.is_action_just_pressed("player_2_rotate_clockwise"):
			add_action(ACTION.ROTATE_CLOCKWISE)
		elif Input.is_action_just_pressed("player_2_rotate_anticlockwise"):
			add_action(ACTION.ROTATE_ANTICLOCKWISE)

func do_action(action : ACTION):
	match action:
		ACTION.FORWARD:
			await move_forward()
		ACTION.ROTATE_CLOCKWISE:
			await rotate_character()
		ACTION.ROTATE_ANTICLOCKWISE:
			await rotate_character(false)
			
func add_action(action : ACTION):
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
