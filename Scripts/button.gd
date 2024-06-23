extends Sprite2D

@onready var press_detection = $press_detection
@onready var colision = $colision

@export_group("Button Settings")
@export var remove_colision = true
@export var delete_object = false

@export_group("Colision Settings")
@export var generate_signal := true
@export var hidable_object : Node2D

signal button_pressed(position:Vector2)

var state := false #false -> not pressed, true -> pressed

func _ready():
	hidable_object.hide_all()
	

func _process(delta):
	if state:
		return
	
	if press_detection.is_colliding():
		state = true
		if generate_signal:
			button_pressed.emit(position)
		
		if hidable_object != null:
			hidable_object.show_all()
		
		if remove_colision:
			colision.queue_free()
		
		if delete_object:
			queue_free()
