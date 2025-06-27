extends Panel

@export var player_1 : bool
@export var player_2_colour : Color
@export var player_2_border_colour : Color
@export var styleBox : StyleBoxFlat
@export var textLabel : RichTextLabel
@export var player : Character
@export var lil_guy : TextureRect

func _ready() -> void:
	if !player_1:
		styleBox = styleBox.duplicate()
		styleBox.bg_color = player_2_colour
		styleBox.border_color = player_2_border_colour
		add_theme_stylebox_override("panel", styleBox)
		textLabel.text = "P2 HEALTH"

func _process(_delta : float) -> void:
	if lil_guy.texture != player.image.texture:
		lil_guy.texture = player.image.texture ## I'm assuming the image from the character was going to be the guy, idk
