extends Area2D

@onready var timer = $timer

@export_group("following")
@export var follow_body := false
@export var followed_body : Node2D
@export_enum("lock x","lock y","lock both") var locking := 2


func _process(delta):
	if not follow_body:
		return
	
	if locking in [0,2]:
		position.x = followed_body.position.x
	
	if locking in [1,2]:
		position.y = followed_body.position.y

func _on_body_entered(body):
	if body is Player:
		print("skill issue")
		Engine.time_scale = 0.5
		timer.start()
		
func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
