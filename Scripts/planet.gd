extends Node2D

@export var speed := 1.0
@export var amplitude := 20.0
@export var gravity := true
@export var small_gravity := false

var offset := 0.0
var time := 0.0
var saved_y := 0

@onready var area_2d = $Area2D
@onready var border = $Border
@onready var border_small = $"Border Small"

func _ready():
	saved_y = position.y
	offset = randf()*3.0
	
	if small_gravity:
		border.visible = false
		border_small.visible = true
	
	if not gravity:
		area_2d.monitoring = false
		border.visible = false
		border_small.visible = false

func _process(delta):
	time += delta
	position.y = saved_y + sin(time*speed+offset)*amplitude
	

func _on_area_2d_body_entered(body):
	if body is Player:
		body.planet_enter(self)


func _on_area_2d_body_exited(body):
	if body is Player:
		body.planet_exit(self)

#for hiding and showing purpose

func hide_all():
	visible = false
	$Area2D/CollisionShape2D.disabled = true
	$StaticBody2D/CollisionShape2D.disabled = true

func show_all():
	visible = true
	$Area2D/CollisionShape2D.disabled = false
	$StaticBody2D/CollisionShape2D.disabled = false
