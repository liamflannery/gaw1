extends Effect
class_name SpiderWeb

func apply_effect(this_tile : Tile, character : Character):
	if !this_tile.has_meta("trapped_characters"):
		this_tile.set_meta("trapped_characters", [character])
	elif !this_tile.get_meta("trapped_characters").has(character):
		var current_characters = this_tile.get_meta("trapped_characters")
		current_characters.append(character)
		this_tile.set_meta("trapped_characters", current_characters)
	else:
		var current_characters = this_tile.get_meta("trapped_characters")
		current_characters.erase(character)
		this_tile.set_meta("trapped_characters", current_characters)

		

func can_player_move(this_tile : Tile, character : Character) -> bool:
	if !this_tile.has_meta("trapped_characters"):
		return true
	return this_tile.get_meta("trapped_characters").has(character)
