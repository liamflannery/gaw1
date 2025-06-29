extends TextureRect
class_name Tile

@export var trap : Trap
@export var starting_effects : Array[Effect]
var effects : Array[EffectObject]
var tile_position : int

func _ready() -> void:
	if !trap:
		%trap_texture.texture = null
	else:
		%trap_texture.texture = trap.trap_texture

	for effect in starting_effects:
		add_effect(effect)

var current_characters : Array[Character]

func character_entered(character : Character):
	if character not in current_characters:
		current_characters.append(character)

func character_exited(character : Character):
	if character in current_characters:
		current_characters.erase(character)

func apply_traps():
	if trap and !current_characters.is_empty():
		for character in current_characters:
			await trap.apply_trap(self, character)

func apply_effects():
	for effect in effects:
		for character in current_characters:
			await effect.effect_resource.apply_effect(self, character)

func turn_ended():
	if trap and !current_characters.is_empty():
		for character in current_characters:
			await trap.turn_ended(self, character)
	for effect in effects:
		await effect.effect_resource.turn_ended(self)

class EffectObject:
	var effect_resource : Effect
	var child_num : int
	func _init(resource : Effect, texture_child_number : int):
		effect_resource = resource
		child_num = texture_child_number


@onready var effect_texture_scene : PackedScene = load("res://scenes/effect_texture.tscn")
func add_effect(effect : Effect):
	if effect in effects.map(func(a): return a.effect_resource): return
	var effect_texture = effect_texture_scene.instantiate()
	effect_texture.texture = effect.effect_texture
	add_child(effect_texture)
	effects.append(EffectObject.new(effect, effect_texture.get_index()))

func remove_effect(effect : Effect):
	for effect_object in effects:
		if effect_object.effect_resource == effect:
			var effect_texture = get_child(effect_object.child_num)
			remove_child(effect_texture)
			effect_texture.queue_free()
			effects.erase(effect_object)
