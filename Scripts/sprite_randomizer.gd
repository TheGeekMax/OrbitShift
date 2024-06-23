extends Sprite2D

@export var SpriteArray : Array[Texture2D]
@export var randomize_color : bool = false
@export var randomize_rotation : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = SpriteArray.pick_random()
	if randomize_color:
		modulate = Color(randf(),randf(),randf())
	if randomize_rotation:
		rotate(randf()*2*PI)
