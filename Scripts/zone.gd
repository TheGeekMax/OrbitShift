extends CollisionShape2D

@onready var gravity_zone = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	shape = RectangleShape2D.new()
	shape.size = gravity_zone.get_collision_size()
