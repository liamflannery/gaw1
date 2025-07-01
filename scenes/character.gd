extends Control
class_name Character

@onready var grid : Grid = get_tree().get_first_node_in_group("grid")
@export var image : TextureRect

@export var input_checks : HBoxContainer
@export var input_complete_icon : NinePatchRect
@export var health_ui : HealthUI
var health : int = 3 :
	set(value):
		health = value
		if health_ui:
			health_ui.set_health(health)
var current_tile : Tile
var dead : bool


enum DIRECTION{
	UP, LEFT, RIGHT, DOWN
}
var inputs : Array[DIRECTION]
var ready_to_move : bool = false
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	current_tile = grid.all_tiles.pick_random()
	set_tile(current_tile, true)

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
	
func stumble_into_tile(this_tile : Tile):
	if !this_tile:
		return
	if move_tween and move_tween.is_running():
		move_tween.custom_step(1000000)
		move_tween.kill()
	
	var target_position = this_tile.global_position - size/2 + this_tile.size/2
	var original_position = global_position
	target_position = (target_position + original_position)/2
	move_tween = create_tween()
	move_tween.tween_property(self, "global_position", target_position, 0.2)
	if move_tween: await move_tween.finished
	move_tween.kill() ## this prolly isn't necessary?
	move_tween = create_tween()
	move_tween.tween_property(self, "global_position", original_position, 0.2)
	## also add a rotate/shake tween here?
	
	if move_tween: await move_tween.finished


func move_in_direction(direction : DIRECTION, succeed : bool):
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
	if succeed:
		await set_tile(target_tile)
	else:
		await stumble_into_tile(target_tile)
	



func predict_action(action : DIRECTION) -> Tile:
	var return_tile = current_tile
	match action:
		DIRECTION.UP:
			return_tile = grid.get_north_tile(current_tile)
		DIRECTION.DOWN:
			return_tile = grid.get_south_tile(current_tile)
		DIRECTION.LEFT:
			return_tile = grid.get_west_tile(current_tile)
		DIRECTION.RIGHT:
			return_tile = grid.get_east_tile(current_tile)
	
	if return_tile:
		return return_tile
	else:
		return current_tile
	

func do_action(action : DIRECTION, succeed : bool):
	for effect : Tile.EffectObject in current_tile.get_effects():
		if !effect.effect_resource.can_player_move(current_tile, self):
			return
	await move_in_direction(action, succeed)

func damage_player(amount : int):
	health -= amount
	if health <= 0:
		kill_player()

func kill_player():
	if dead:
		return
	dead = true
	
	image.flip_v = true
	image.modulate = Color(0.1, 0.1, 0.1, 1)
	health_ui.lil_guy.flip_v = true
	health_ui.lil_guy.modulate = Color(0.1, 0.1, 0.1, 1)
	#Stage.playerDead += 1 if player_1 else 2 ## this way if both players die together we'll know because it'll be 3 lol
	pass
	
func add_action(action : DIRECTION):
	if inputs.size() >= 4:
		return
	inputs.append(action)
	
func clear_actions():
	inputs.clear()
	input_complete_icon.hide()
