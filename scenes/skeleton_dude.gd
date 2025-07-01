extends Character
class_name NPC

@export var up_arrow : Texture
@export var down_arrow : Texture
@export var left_arrow : Texture
@export var right_arrow : Texture

func choose_actions():
	add_action(DIRECTION[DIRECTION.keys().pick_random()])
	add_action(DIRECTION[DIRECTION.keys().pick_random()])
	add_action(DIRECTION[DIRECTION.keys().pick_random()])
	add_action(DIRECTION[DIRECTION.keys().pick_random()])



func add_action(direction : DIRECTION):
	super(direction)
	var this_input = input_checks.get_child(inputs.size() - 1)
	match direction:
		DIRECTION.UP:
			this_input.texture = up_arrow
		DIRECTION.DOWN:
			this_input.texture = down_arrow
		DIRECTION.LEFT:
			this_input.texture = left_arrow
		DIRECTION.RIGHT:
			this_input.texture = right_arrow
	this_input.show()
	input_checks.show()
			
		
	
