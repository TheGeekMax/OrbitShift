class_name GameManager
extends Node

# constants
@export_group("Constants")
## Player
const SPEED = 10.0
const EJECT_SPEED = 5
const JUMP_VELOCITY = -800.0
const MAX_LENGTH_LINE = 1000
const DEFAULT_JUMP_COUNT = 2
const DASH_COOLDOWN = 5
const DASH_FLY_TIME = .2
const DASH_SPEED = 2000

# values
@export_group("Values")
## Player
@export_subgroup("Player")
### Movements
@export var default_gravity_vector = Vector2(0,1)

var max_jump := DEFAULT_JUMP_COUNT
var jump_count := max_jump:
	set(value):
		jump_count = value
		$"../UI/DataBar".define_value(value)

### Dash
var dashing := false
var dash_time : float = 0:
	set(value):
		dash_time = value
		if dash_time < 0:
			dash_time = 0
			dashing = false
		else:
			dashing = true
var dash_cooldown : float = 0:
	set(value):
		dash_cooldown = value
		if dash_cooldown < 0:
			dash_cooldown= 0

# methods

## Player
func jump_increment(value : int) -> void:
	max_jump += value


# methods of Node
@onready var dash_cooldown_progress = $"../UI/dashCooldown"

func _process(delta):
	if dash_time > 0:
		dash_time -= delta
		
	if dash_cooldown > 0:
		dash_cooldown -= delta
		dash_cooldown_progress.value = 1-dash_cooldown/DASH_COOLDOWN
