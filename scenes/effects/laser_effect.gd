extends Effect
class_name LaserEffect

func apply_effect(this_tile : Tile, character : Character):
	await character.damage_player(1)

func turn_ended(this_tile: Tile):
	this_tile.remove_effect(self)
