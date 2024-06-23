class_name ParentSnapper

extends Area2D

@export var floating = false
var collide_body:Node2D
var inside := false

var time = 0
var floating_vector := Vector2(0,0)

#used variables
var relative_position :Vector2

func _process(delta):
	if floating:
		time += delta
	
	if inside:
		get_parent().position = collide_body.position + relative_position + floating_vector*sin(time*2.0)*25.0

# fonctions sur l'area 2D
func _on_area_entered(body):
	if body.is_in_group("Snapable"):
		inside = true
		collide_body = body.get_parent()
		relative_position = get_parent().position - collide_body.position 
		get_parent().rotation = relative_position.angle() + PI/2
		
		if floating:
			floating_vector = relative_position.normalized()
