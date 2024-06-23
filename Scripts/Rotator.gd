extends Sprite2D

@export_range(0.,2.,0.01) var speed := 1.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(delta*speed)
