@tool
extends Sprite2D

enum ORIENTATION_TYPE {UP,RIGHT,BOTTOM,LEFT}

@export_group("Gravity Zone")
@export var upColor:Color= Color.BLACK
@export var downColor:Color= Color.BLACK
@export var leftColor:Color= Color.BLACK
@export var rightColor:Color= Color.BLACK

@export_group("others")
@export var cell_size:Vector2i = Vector2i(1,1)
@export var orientation: ORIENTATION_TYPE= ORIENTATION_TYPE.UP

func _process(delta):
	modulate = [upColor,rightColor,downColor,leftColor][orientation]
	if orientation in [ORIENTATION_TYPE.LEFT,ORIENTATION_TYPE.RIGHT]:
		rotation = 0
		region_rect.size.x = cell_size.x*128
		region_rect.size.y = cell_size.y*128
		if orientation == ORIENTATION_TYPE.LEFT:
			flip_h = false
		else:
			flip_h = true
	else:
		rotation = PI/2
		region_rect.size.x = cell_size.y*128
		region_rect.size.y = cell_size.x*128
		if orientation == ORIENTATION_TYPE.UP:
			flip_h = false
		else:
			flip_h = true
	
	
func get_collision_size() -> Vector2:
	if orientation in [ORIENTATION_TYPE.LEFT,ORIENTATION_TYPE.RIGHT]:
		return Vector2(cell_size.x*128,cell_size.y*128)
	else:
		return Vector2(cell_size.y*128,cell_size.x*128)

func get_vector_gravity() -> Vector2:
	if orientation == ORIENTATION_TYPE.UP:
		return Vector2(0,-1)
	elif orientation == ORIENTATION_TYPE.RIGHT:
		return Vector2(1,0)
	elif orientation == ORIENTATION_TYPE.BOTTOM:
		return Vector2(0,1)
	elif orientation == ORIENTATION_TYPE.LEFT:
		return Vector2(-1,0)
	return Vector2(0,0)

func _on_area_2d_body_entered(bd):
	if bd is Player:
		bd.enter_force_field(self)



func _on_area_2d_body_exited(bd):
	if bd is Player:
		bd.exit_force_field(self)
