extends Panel
class_name HealthUI
@export var player_1 : bool
@export var player_2_colour : Color
@export var player_2_border_colour : Color
@export var styleBox : StyleBoxFlat
@export var textLabel : RichTextLabel
@export var player : Character
@export var lil_guy : TextureRect
@export var shadowTexture : Texture
@export var heartTexture : Texture

func _ready() -> void:
	if !player_1:
		styleBox = styleBox.duplicate()
		styleBox.bg_color = player_2_colour
		styleBox.border_color = player_2_border_colour
		add_theme_stylebox_override("panel", styleBox)
		textLabel.text = "P2 HEALTH"
		lil_guy.modulate = player_2_border_colour

func set_health(amount : int):
	%heart_1.texture = shadowTexture
	%heart_2.texture = shadowTexture
	%heart_3.texture = shadowTexture
	if amount >= 1:
		%heart_1.texture = heartTexture
	if amount >= 2:
		%heart_2.texture = heartTexture
	if amount >= 3:
		%heart_3.texture = heartTexture
		
