class_name Player

extends CharacterBody2D

@onready var manager := %GameManager

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# for force field
var forced_gravity := false
var forced_vector := Vector2(0,0)
var forced_list : Array[Node2D] = [] 

@onready var player = $Sprite2D
@onready var line = $EjectLine

var gravity_vector = Vector2(0,0)
var planet_array : Array[Node2D] = []
var cooldown := 0.0

var angle :float = 0
var t_vel := Vector2(0,0)

var move_inversion_calculated := false
var inversion = 1

func _physics_process(delta):
	# Add the gravity.
	gravity_vector = get_planet_gravity_normalized_vector()
	set_up_direction(-gravity_vector)
	
	# Calculate dashing property
	if Input.is_action_just_pressed("dash") and manager.dash_cooldown == 0 and not is_on_floor():
		manager.dash_cooldown = manager.DASH_COOLDOWN
		manager.dash_time = manager.DASH_FLY_TIME
		
		# calculate velocity
		
		velocity = velocity.normalized()*manager.DASH_SPEED
		
	# Calculate new velocity
	
	if not is_on_floor() and not manager.dashing:
		velocity += gravity_vector * delta * gravity
	elif cooldown <= 0:
		cooldown = 0
		manager.jump_count = manager.max_jump
	
	if cooldown > 0:
		cooldown -= delta
	
	if not manager.dashing:
		velocity.x = move_toward(velocity.x, 0, GameManager.SPEED)
		velocity.y = move_toward(velocity.y, 0, GameManager.SPEED)
	angle = gravity_vector.angle()-(PI/2)
	
	if abs(player.rotation-angle)> 2*PI-0.1:
		player.rotation = angle
	else:
		player.rotation = move_toward(player.rotation,angle,0.3)
	move_and_slide()
	


func planet_enter(b:Node2D):
	if not b in planet_array:
		planet_array.append(b)

func planet_exit(b:Node2D):
	planet_array.erase(b)

# function to calculate gravityVector
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if manager.jump_count == 0:
					return
				
				#calculate line
				line.visible = true
				var clamped_line := camera_to_screen_pos(event.position) - position
				if clamped_line.length() > GameManager.MAX_LENGTH_LINE:
					clamped_line = clamped_line.normalized()*GameManager.MAX_LENGTH_LINE
				line.points[1] = clamped_line
			else:
				if !line.visible:
					return
				manager.jump_count -= 1
				cooldown = 0.5
				line.visible = false
				var clamped_velocity := camera_to_screen_pos(event.position) - position
				if clamped_velocity.length() > GameManager.MAX_LENGTH_LINE:
					clamped_velocity = clamped_velocity.normalized()*GameManager.MAX_LENGTH_LINE
				velocity += clamped_velocity
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			var clamped_line := camera_to_screen_pos(event.position) - position
			if clamped_line.length() > GameManager.MAX_LENGTH_LINE:
				clamped_line = clamped_line.normalized()*GameManager.MAX_LENGTH_LINE
			line.points[1] = clamped_line

func camera_to_screen_pos(position:Vector2) -> Vector2:
	return get_viewport().get_canvas_transform().affine_inverse() * position

func get_closest_planet() -> Node2D:
	var dist = INF
	var pl : Node2D = null
	for planet in planet_array:
		var d = (planet.position - position).length()
		if d < dist:
			dist = d
			pl = planet
	
	return pl

# for override zone
func enter_force_field(body:Node2D):
	if not body in forced_list:
		forced_gravity = true
		forced_list.append(body)
	

func exit_force_field(body:Node2D):
	if body in forced_list:
		forced_list.erase(body)
	
	if forced_list.is_empty():
		forced_gravity = false
		forced_vector = Vector2(0,0)

func get_forced_gravity_vector():
	var closest : Node2D = forced_list[0]
	var dist := (position-closest.position).length()
	for cur in forced_list:
		if (position-cur.position).length() < dist:
			closest = cur
			dist = (position-cur.position).length()
	return closest.get_vector_gravity()

func get_planet_gravity_normalized_vector() -> Vector2:
	if forced_gravity:
		return get_forced_gravity_vector()
	elif planet_array.is_empty():
		return manager.default_gravity_vector
	var planet = get_closest_planet()
	return (planet.position-position).normalized()*[1,2][int(planet.small_gravity)]
